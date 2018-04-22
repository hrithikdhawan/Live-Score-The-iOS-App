//
//  NewsViewController.swift
//  Live Score
//
//  Created by Siddharth Dhawan on 10/04/18.
//  Copyright © 2018 Siddharth Dhawan. All rights reserved.
//

import UIKit

class CustomNewsCell : UITableViewCell
{
    
    @IBOutlet var source: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var titl: UILabel!
   
}
class NewsViewController : UIViewController , UITableViewDelegate , UITableViewDataSource
{
    @IBOutlet var mTableView: UITableView!
    var count = 0
    var object = News()
    var sports = "nba"
    
    var dateFormator = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormator.timeZone = TimeZone(abbreviation: "GMT+5:30")
        dateFormator.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormator.dateStyle = .medium
        dateFormator.timeStyle = .short
        count = object.newsRequest()
        if count == 0
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: mTableView.bounds.size.width, height: mTableView.bounds.size.height))
            noDataLabel.text          = "No data/internet connection available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            mTableView.backgroundView  = noDataLabel
            mTableView.separatorStyle  = .none
        }
        mTableView.reloadData()
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newscell") as! CustomNewsCell
        cell.source.text = object.src[indexPath.row]
        cell.time.text = dateFormator.string(from: object.date[indexPath.row])
        cell.titl.text = object.title[indexPath.row] + "\n\n"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if object.decription[indexPath.row] != ""
        {
            let cell = tableView.cellForRow(at: indexPath) as! CustomNewsCell
            cell.titl.text = object.decription[indexPath.row]
            
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CustomNewsCell
        cell.titl.text = object.title[indexPath.row]
    }
   
    
    
}
