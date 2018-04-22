//
//  JSONResult.swift
//  Live Score
//
//  Created by Siddharth Dhawan on 05/02/18.
//  Copyright © 2018 Siddharth Dhawan. All rights reserved.
//

import Foundation
class JSONResult
{
    struct DataObject
    {
        var homeTeam = [String](repeating: "", count: 50)
        var awayTeam = [String](repeating: "", count: 50)
        var status = [String](repeating: "SCHEDULED", count: 50)
        var date = [String](repeating: "", count: 50)  // GMT+5:30
        var homeGoals = [Int?](repeating: nil, count: 50)
        var awayGoals = [Int?](repeating: nil, count: 50)
    }
    var dateFormator = DateFormatter()
    var count = [Int]()
    var collapse = [Bool]()
    var objectData = [DataObject]()
    var queryParam = ""
    //let today : Date
    var selected : String
   // var past = 0
    //let semaphore = DispatchSemaphore(value: 0)
    let semaphore2 = DispatchSemaphore(value: 0)
    init(idCount: Int,selectedDate: Date) {
        count = [Int](repeating: 0, count: idCount)
        //semaphore2 = DispatchSemaphore(value: idCount)
        collapse = [Bool](repeating: false, count: idCount)
        objectData = [DataObject](repeating: DataObject(), count: idCount)
        dateFormator.timeZone = TimeZone(abbreviation: "GMT+5:30")
        dateFormator.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
   
        let today = dateFormator.date(from: dateFormator.string(from: Date()))!
        //print(today)
        //print(selectedDate)
        selected = dateFormator.string(from: selectedDate)
        print(selected)
        if selectedDate > today  // check
        {
            queryParam = "timeFrame=n30"
            //print("future")
        }
        else
        {
            queryParam = "timeFrame=p30"
            //print("past")
        }
    }
    
    private struct football : Decodable
    {
        let _links : Links
        let count : Int
        let fixtures : [fixture]
        
    }
    private struct fixture : Decodable
    {
        let _links : Links
        let date : String
        let status : String?
        let matchday : Int?
        let homeTeamName : String
        let awayTeamName : String
        let result : results
    }
    private struct results : Decodable
    {
        let goalsHomeTeam : Int?
        let goalsAwayTeam : Int?
        
        
    }
    private struct Links : Decodable{
        let competition : Compet
        
    }
    private struct Compet : Decodable{
        let href : String
    }
    
    func resultRequest(id : Int ,idIndex : Int)
    {
        let baseUrl = "https://api.football-data.org/v1/competitions/"
        let resultUrl = URL(string: baseUrl+"\(id)"+"/fixtures/?X-Auth-Token=fcb931c8492b42cb923d35f86a117d66&"+queryParam)!
        //758f6a6a69cb423c96ee8bee36b12628
        URLSession.shared.dataTask(with: resultUrl, completionHandler: {
            data, response, error in
            guard let data = data else {return}
            do
            {
                let decoder=JSONDecoder()
                let mydata = try decoder.decode(football.self, from: data)
                var index = 0
        
                for i in 0..<max(0,mydata.count)
                {
                 
                    let myDate = self.dateFormator.string(from: self.dateFormator.date(from: mydata.fixtures[i].date)!)
                    //print(myDate)
                    if self.selected.prefix(10) ==  myDate.prefix(10)
                    {
                        self.objectData[idIndex].date[index] = myDate
                        self.objectData[idIndex].status[index] = mydata.fixtures[i].status!
                        self.objectData[idIndex].homeTeam[index] = mydata.fixtures[i].homeTeamName
                        self.objectData[idIndex].awayTeam[index] = mydata.fixtures[i].awayTeamName
                        self.objectData[idIndex].awayGoals[index] = mydata.fixtures[i].result.goalsAwayTeam
                        self.objectData[idIndex].homeGoals[index] = mydata.fixtures[i].result.goalsHomeTeam
                        index = index+1
                    }
                    //print(self.homeTeam[index])
                     self.count[idIndex] = index
                }
                self.semaphore2.signal()
            }
            catch let err
            {
                print(err)
            }
            
        }).resume()
    }
}
class LeagueTable
{
    var stand = [MyStand]()
    struct MyStand {
        var position : Int = 0
        var teamsName : String = ""
        var playedGame : Int = 0
        var points : Int = 0
        var goals : Int = 0
        var goalsAgainst : Int = 0
        var goalDifference : Int = 0
        var wins : Int = 0
        var draws: Int = 0
        var loses : Int = 0
    }
    private struct leagueTable : Decodable
    {
        let leagueCaption : String?
        let matchday : Int?
        let standing :  [standings]
    }
    private struct standings : Decodable
    {
        let position : Int
        let teamName : String
        let playedGames : Int
        let points : Int
        let goals : Int
        let goalsAgainst : Int
        let goalDifference : Int
        let wins : Int
        let draws: Int
        let losses : Int
    }
    func leagueResult(id: Int) -> Int
    {
        let url = URL(string: "https://api.football-data.org/v1/competitions/\(id)/leagueTable")
        let semaphore = DispatchSemaphore(value: 0)
        var c = 0
        URLSession.shared.dataTask(with: url!, completionHandler: {
            data, response, error in
            guard let data = data else {return}
            do
            {
                let decoder = JSONDecoder()
                let recievedData = try decoder.decode(leagueTable.self, from: data)
                c = recievedData.standing.count
                self.stand = [MyStand](repeating: MyStand(), count: c)
                for i in 0...c-1
                {
                    self.stand[i].goalDifference = recievedData.standing[i].goalDifference
                    self.stand[i].draws = recievedData.standing[i].draws
                    self.stand[i].goals = recievedData.standing[i].goals
                    self.stand[i].goalsAgainst = recievedData.standing[i].goalsAgainst
                    self.stand[i].loses = recievedData.standing[i].losses
                    self.stand[i].playedGame = recievedData.standing[i].playedGames
                    self.stand[i].wins = recievedData.standing[i].wins
                    self.stand[i].teamsName = recievedData.standing[i].teamName
                    //print(self.stand[i].teamsName)
                    self.stand[i].points = recievedData.standing[i].points
                    self.stand[i].position = recievedData.standing[i].position
                }
                semaphore.signal()
                
            }
            catch let err
            {
                print(err)
            }
        }).resume()
        _ = semaphore.wait()
        return c
    }
}
