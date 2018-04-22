//
//  CricketMainViewController.swift
//  Live Score
//
//  Created by Siddharth Dhawan on 13/03/18.
//  Copyright © 2018 Siddharth Dhawan. All rights reserved.
//
import UIKit

class CustomCricketCell : UITableViewCell
{
    @IBOutlet var type: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var home: UILabel!
    @IBOutlet var homeScore: UILabel!
    @IBOutlet var away: UILabel!
    @IBOutlet var awayScore: UILabel!
    //@IBOutlet var result: UILabel!
    
}
class CricketScoreController : UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var mTable: UITableView!
    var object = CricketResponse()
    var dateFormator = DateFormatter()
    var count = 0
    var included = [Bool](repeating: true, count: 5)
    override func viewDidLoad() {
        super.viewDidLoad()
        // NotificationCenter.default.addObserver(self, selector: #selector(loadData(_:)), name: NSNotification.Name("filter"), object: nil)
        dateFormator.timeZone = TimeZone(abbreviation: "GMT+5:30")
        dateFormator.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormator.dateStyle = .medium
        dateFormator.timeStyle = .short
        loadData()
    }
    func loadData()
    {
        let count = object.cricketMatches(included: included)
        self.count = count
        if count == 0
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: mTable.bounds.size.width, height: mTable.bounds.size.height))
            noDataLabel.text          = "No data/internet connection available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            mTable.backgroundView  = noDataLabel
            mTable.separatorStyle  = .none
        }
       
        else
        {
            mTable.reloadData()
            for i in 0..<count
            {
                object.updateScore(index: i)
            }
            object.semaphore2.wait()
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CustomCricketCell
        var s = object.Score[indexPath.row]
        //print(s)
        if(s != "" && object.started[indexPath.row])
        {
            var index = s.index(of: "v")
            while(s[s.index(index!, offsetBy: 1)] != " ")
            {
                s = String(s[s.index(after: index!)...])
                index = s.index(of: "v")
                //print("in while")
            }
            cell.homeScore.text = String(s[s.index(index!, offsetBy: -8)...s.index(index!, offsetBy: -1)])
            cell.awayScore.text = String(s[s.index(s.endIndex, offsetBy: -8)...])
        }
        else
        {
            cell.homeScore.text = "NA"
            cell.awayScore.text = "NA"
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CustomCricketCell
        if object.started[indexPath.row]
        {
            cell.homeScore.text = "Toss: "
            cell.awayScore.text = object.toss[indexPath.row]
        }
        else
        {
            cell.homeScore.text = "NA"
            cell.awayScore.text = "NA"
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cricketCell", for: indexPath) as! CustomCricketCell
       
        cell.away.text = object.awayTeam[indexPath.row]
        cell.home.text = object.homeTeam[indexPath.row]
        cell.type.text = object.type[indexPath.row]
        cell.time.text = dateFormator.string(from: object.time[indexPath.row])
        cell.homeScore.text = "Toss: "
        cell.awayScore.text =  object.toss[indexPath.row]
        return cell
    }
    func setIncluded(included: [Bool])
    {
        self.included = included
        loadData()
    }
}


