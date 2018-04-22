//
//  SecondViewController.swift
//  Live Score
//
//  Created by Siddharth Dhawan on 18/02/18.
//  Copyright © 2018 Siddharth Dhawan. All rights reserved.
//

import UIKit
class SecondViewController : UIViewController
{
    var date: Date = Date(timeIntervalSinceNow: -24*60*60)
    var dateFormator = DateFormatter()
    var selectedDate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormator.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ";
        dateFormator.timeZone = TimeZone(abbreviation: "GMT+5:30");
        let myDate = dateFormator.date(from: dateFormator.string(from: date))
        let selectedDate :[String : Date] = ["date" : myDate!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue : "load"), object: nil, userInfo: selectedDate)
      
        
       
    }
}
