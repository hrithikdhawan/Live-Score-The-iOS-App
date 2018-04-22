//
//  SmallTableViewController.swift
//  Live Score
//
//  Created by Siddharth Dhawan on 03/03/18.
//  Copyright © 2018 Siddharth Dhawan. All rights reserved.
//
import UIKit
class Cell : UICollectionViewCell
{
    
    @IBOutlet var textButton: UIButton!
}
class SmallCollectionViewController : UICollectionViewController
{
    var days = [String](repeating: "1", count: 15)
    let c = 24*60*60
    var date: Date = Date()
    var dateFormator = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormator.timeZone = TimeZone(abbreviation: "GMT+5:30")
        dateFormator.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        date = Date()
        for i in 0...14
        {
            let s = dateFormator.string(from: Date(timeIntervalSinceNow: TimeInterval((i-7)*c)))
            days[i] = String(s[s.index(s.startIndex, offsetBy: 5)...s.index(s.startIndex, offsetBy: 9)])
        }
//        let myDate =  dateFormator.string(from:Date(timeIntervalSinceNow: TimeInterval(-1*c)))
//        let selectedDate :[String : Date] = ["date" : dateFormator.date(from: myDate)!]
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue : "load"), object: nil, userInfo: selectedDate)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let midCell = IndexPath(item: 7, section: 0)
        self.collectionView?.scrollToItem(at: midCell, at: .centeredHorizontally, animated: true)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! Cell
        cell.textButton.setTitle(days[indexPath.item], for: .normal)
        cell.textButton.tag = indexPath.item
        return cell
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }

    @IBAction func toggleDay(_ sender: UIButton)
    {
        let item = sender.tag - 7
        date = Date(timeIntervalSinceNow: TimeInterval(item*c))
        let myDate = dateFormator.string(from: date)
        //print(myDate)
        let selectedDate :[String : Date] = ["date" : dateFormator.date(from: myDate)!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue : "load"), object: nil, userInfo: selectedDate)
        
    }
   
    
    
}
