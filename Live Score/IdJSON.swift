//
//  IdJSON.swift
//  Live Score
//
//  Created by Siddharth Dhawan on 01/03/18.
//  Copyright © 2018 Siddharth Dhawan. All rights reserved.
//

import Foundation
import SystemConfiguration

public class Reachability { // taken fom web
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
        
        
    }
}
class IdJSON
{
    struct competitions  : Decodable
    {
        let Object: [competition]
    }
    struct competition  : Decodable
    {
        let id : Int
        let caption : String
    }
    
    var idCount : Int = 0
    var id = [Int]()
    var caption = [String]()
    let semaphore = DispatchSemaphore(value: 0)
    
    func idRequest() -> Int
    {
        if Reachability.isConnectedToNetwork()
        {
            let url = URL(string: "https://api.football-data.org/v1/competitions/?X-Auth-Token=fcb931c8492b42cb923d35f86a117d66")
            //758f6a6a69cb423c96ee8bee36b12628
            URLSession.shared.dataTask(with: url!, completionHandler: {
                data ,response, error in
                guard let data = data else {return}
                do
                {
                    let decoder = JSONDecoder()
                    let recievedData = try decoder.decode([competition].self, from: data)
                    let idCount = recievedData.count
                    self.idCount = idCount
                    //print(idCount)
                    self.id = [Int](repeating: 0, count: idCount)
                    self.caption = [String](repeating: "", count: idCount)
                    for index in 0...idCount-1
                    {
                        self.id[index] = recievedData[index].id
                        self.caption[index] = recievedData[index].caption
                    }
                    self.semaphore.signal()
                }
                catch let err
                {
                    print(err)
                }
            }).resume()
            _ = semaphore.wait()
        }
        return idCount
    }
}
