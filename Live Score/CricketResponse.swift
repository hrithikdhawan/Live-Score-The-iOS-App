//
//  CricketResponse.swift
//  Live Score
//
//  Created by Siddharth Dhawan on 17/03/18.
//  Copyright © 2018 Siddharth Dhawan. All rights reserved.
//

import Foundation
class CricketResponse
{
    struct root : Decodable
    {
        let matches : [match]
    }
    struct match : Decodable
    {
        let unique_id: Int
        let team2: String
        let team1: String
        let type: String
        let dateTimeGMT: String
        let squad: Bool
        let matchStarted: Bool
        let toss_winner: String?
        let winner_team: String?
        private enum CodingKeys : String, CodingKey
        {
            case unique_id = "unique_id"
            case team2 = "team-2"
            case team1 = "team-1"
            case type = "type"
            case squad = "squad"
            case matchStarted = "matchStarted"
            case dateTimeGMT = "dateTimeGMT"
            case winner_team = "winner_team"
            case toss_winner = "toss_winner_team"
        }
    }
     let match = ["ListA","First-class","WomensODI","ODI","Twenty20"]
    var matchId = [Int]()
    var type = [String]()
    var time = [Date]()
    var winner = [String]()
    var toss = [String]()
    var started = [Bool]()
    var homeTeam = [String]()
    var awayTeam = [String]()
    var Score = [String]()
    let semaphore = DispatchSemaphore(value: 0)
    var semaphore2 = DispatchSemaphore(value: 0)
     var dateFormator = DateFormatter()
    
    func cricketMatches(included: [Bool]) -> Int
    {
        let url = URL(string: "https://cricapi.com/api/matches?apikey=7JxL5nv2PwdRlT5Igal9OSEcnPu2")
        var index = 0
         var count = 0
        if Reachability.isConnectedToNetwork()
        {
            URLSession.shared.dataTask(with: url!, completionHandler:{
                data ,response ,error in
                guard let data = data else { print("unguarded"); return}
                do
                {
                    let decoder = JSONDecoder()
                    // print("decoding")
                    let recieved = try decoder.decode(root.self, from: data)
                    count = recieved.matches.count
                    if count>10
                    {
                        count = 10
                    }
                    self.homeTeam = [String](repeating: "", count: count)
                    self.awayTeam = [String](repeating: "", count: count)
                    self.Score = [String](repeating: "", count: count)
                    self.matchId = [Int](repeating: 0, count: count)
                    self.time = [Date](repeating: Date(), count: count)
                    self.type = [String](repeating: "", count: count)
                    self.toss = [String](repeating: "", count: count)
                    self.winner = [String](repeating: "", count: count)
                    self.started = [Bool](repeating: false, count: count)
                    self.dateFormator.timeZone = TimeZone(abbreviation: "GMT+5:30")
                    self.dateFormator.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    //self.semaphore2 = DispatchSemaphore(valu)
                    
                    for i in 0..<count
                    {
                        let c = recieved.matches[i].type
                        //print(c)
                        if ((included[0] && c == self.match[0])  || (included[1] && c == self.match[1]) || (included[2] && c == self.match[2]) || (included[3] && c == self.match[3])  ||  (included[4] && c == self.match[4]))
                        {
                            self.homeTeam[index] = recieved.matches[i].team1
                            self.awayTeam[index] = recieved.matches[i].team2
                            //print(recieved.matches[i].dateTimeGMT)
                            self.time[index] = self.dateFormator.date(from: recieved.matches[i].dateTimeGMT)!
                            self.matchId[index] = recieved.matches[i].unique_id
                            self.type[index] = recieved.matches[i].type
                            self.started[index] = recieved.matches[i].matchStarted
                            if(self.started[index])
                            {
                                if recieved.matches[i].toss_winner != nil
                                {
                                    self.toss[index] = recieved.matches[i].toss_winner!
                                    //self.winner[i] = recieved.matches[i].winner_team!
                                }
                            }
                            else
                            {
                                self.toss[index] = ""
                            }
                            index = index + 1
                        }
                    }
                    
                    self.semaphore.signal()
                }
                catch let err
                {
                    print(err)
                }
            }
                ).resume()
            semaphore.wait()
        }
        return index
    }
    
    struct rootScore : Decodable {
        let score : String
        let matchStarted: Bool
    }
    
    func updateScore(index: Int)
    {
        let url = URL(string: "https://cricapi.com/api/cricketScore?apikey=7JxL5nv2PwdRlT5Igal9OSEcnPu2&unique_id=\(matchId[index])")
        URLSession.shared.dataTask(with: url!, completionHandler: {
            data, resonse, error in
            guard let data = data else {return}
            do
            {
                let decoder = JSONDecoder()
                let recieved = try decoder.decode(rootScore.self, from: data)
                if recieved.matchStarted
                {
                    self.Score[index] = recieved.score
                    
                }
                else
                {
                    self.Score[index] = ""
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
