//
//  News.swift
//  Live Score
//
//  Created by Siddharth Dhawan on 10/04/18.
//  Copyright © 2018 Siddharth Dhawan. All rights reserved.
//

import Foundation

class News
{
    struct Root: Decodable
    {
        let totalResults: Int?
        let articles: [article]
    }
    struct article: Decodable {
        let source : Source
        let author : String?
        let title : String?
        let description : String?
        let publishedAt : String
        
    }
    struct Source: Decodable {
        let name : String?
    }
    let semaphore = DispatchSemaphore(value: 0)
    var title = [String]()
    var src = [String]()
    var decription = [String]()
    var date = [Date]()
    var dateFormator = DateFormatter()
    static var sports = "nba"
    //var sports = ""
    func set(sp : String)
    {
        News.sports = sp
    }
    func newsRequest() -> Int
    {
         dateFormator.dateFormat = "yyyy-MM-dd"
        let baseUrl = "https://newsapi.org/v2/everything?q=\(News.sports)&apiKey=d2302b9913a844efba06c5ea9ff01c7e&from="+dateFormator.string(from: Date())+"&sortBy=relevancy&language=en"
        
        let url = URL(string: baseUrl)
        dateFormator.timeZone = TimeZone(abbreviation: "GMT+5:30")
        dateFormator.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var count = 0
         if Reachability.isConnectedToNetwork()
         {
            URLSession.shared.dataTask(with: url!, completionHandler: {
                data, resonse, error in
                guard let data = data else {return}
                do
                {
                    let jsonDecoder = JSONDecoder()
                    let recievedData = try jsonDecoder.decode(Root.self, from: data)
                    count = recievedData.totalResults!
                    if count > 20
                    {
                        count = 20
                    }
                    self.title = [String](repeating: "", count: count)
                    self.decription = [String](repeating: "", count: count)
                    self.src = [String](repeating: "", count: count)
                    self.date = [Date](repeating: Date(), count: count)
                    for i in 0..<count
                    {
                        if ((recievedData.articles[i].title) != nil)
                        {
                            self.title[i] = recievedData.articles[i].title!
                        }
                        else
                        {
                            self.title[i] = ""
                        }
                        //print(self.title[i])
                        if ((recievedData.articles[i].description) == nil)
                        {
                            self.decription[i] = ""
                        }
                        else
                        {
                            self.decription[i] = recievedData.articles[i].description!
                            
                        }
                        //print(self.decription[i])
                        self.date[i] = self.dateFormator.date(from: recievedData.articles[i].publishedAt)!
                        self.src[i] = recievedData.articles[i].source.name!
                    }
                    
                }
                catch let err
                {
                    print(err)
                }
                self.semaphore.signal()
            }).resume()
            semaphore.wait()
        }
        return count
    }
}
