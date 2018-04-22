//
//  TableViewController.swift
//  Live Score
//
//  Created by Siddharth Dhawan on 12/02/18.
//  Copyright © 2018 Siddharth Dhawan. All rights reserved.
//

import UIKit

class CustomHeaderCell : UITableViewCell
{
    @IBOutlet var toggleButton: UIButton!
    
    @IBOutlet var titleButton: UIButton!
    
    
}
class CustomRowCell : UITableViewCell
{
    
    @IBOutlet var homeTeam: UILabel!
    @IBOutlet var home: UILabel!
    @IBOutlet var differentiator: UILabel!
    @IBOutlet var away: UILabel!
    @IBOutlet var awayTeam: UILabel!
    
   
}
class FootballScoreController : UIViewController, UITableViewDataSource, UITableViewDelegate
{
   
    
    @IBOutlet var myTableView: UITableView!
    var object = JSONResult(idCount: 0, selectedDate: Date())
    var id = [Int]()
    var idCount = 0
    var flag = false
    var caption = [String]()
    var dateFormator = DateFormatter()

    @IBAction func toglgleAction(_ sender: UIButton)
    {
        let section = sender.tag
        let colapsed = object.collapse[section]
        object.collapse[section] = !colapsed
        if colapsed
        {
            sender.titleLabel?.text = "v"
        }
        else
        {
            sender.titleLabel?.text = "^"
        }
        myTableView.reloadSections(IndexSet(integer : section), with: .automatic)
    }
    @IBAction func leagueTable(_ sender: UIButton)
    {
        _ = StandingViewController(id: id[sender.tag])
    }
    override func viewDidLoad()
    {
         super.viewDidLoad()
        //myTableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData(_:)), name: NSNotification.Name("load"), object: nil)
       
        dateFormator.timeZone = TimeZone(abbreviation: "GMT+5:30")
        dateFormator.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let IdResult = IdJSON()
        idCount = IdResult.idRequest()
        print(idCount)
        if idCount != -1
        {
            id =  IdResult.id
            caption = IdResult.caption
        }
        else
        {
            myTableView.reloadData()
        }
        if idCount > 0
        {
            let myDate =  dateFormator.date(from: dateFormator.string(from:Date()))
            object = JSONResult(idCount :idCount,selectedDate : myDate!)
            for index in 0...3//idCount - 1
            {
                object.resultRequest(id: id[index],idIndex: index)
                object.semaphore2.wait()
            }
            
            var f = false
            for index in 0...3//idCount - 1
            {
                f = f || object.count[index] != 0
            }
            flag = f
        }
        self.myTableView.reloadData()
    }


    
    @objc func loadData(_ notification: Notification)
    {
        object = JSONResult(idCount :idCount,selectedDate :notification.userInfo!["date"] as! Date)
        if idCount > 0
        {
            for index in 0...5//idCount - 1
            {
                object.resultRequest(id: id[index],idIndex: index)
                object.semaphore2.wait()
            }
            
            var f = false
            for index in 0...5//idCount - 1
            {
                f = f || object.count[index] != 0
            }
            flag = f
        }
        self.myTableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if idCount>0
        {
            numOfSections = idCount
            for i in 0..<object.count.count
            {
                if object.count[i] == 0
                {
                    numOfSections = numOfSections - 1
                }
            }
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No data/internet connection available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        if !flag
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No fixtures available today"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        else
        {
            tableView.backgroundView = nil
        }
        
        return numOfSections
    }
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "headercell") as! CustomHeaderCell
        header.titleButton.setTitle(caption[section], for: .normal)
        header.titleButton.tag = section
        header.toggleButton.tag = section
        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var numOfRows: Int = 0
        tableView.separatorStyle = .none
        if object.count[section] > 0
        {
            tableView.separatorStyle = .none
            tableView.separatorColor = .blue
            numOfRows = object.count[section]
            
        }
        return object.collapse[section] ? 0 : numOfRows
       
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rowcell", for: indexPath) as! CustomRowCell
        cell.backgroundColor = UIColor.lightText
        cell.homeTeam.text = object.objectData[indexPath.section].homeTeam[indexPath.row]
        cell.awayTeam.text = object.objectData[indexPath.section].awayTeam[indexPath.row]
        if object.objectData[indexPath.section].status[indexPath.row] == "FINISHED" || object.objectData[indexPath.section].status[indexPath.row] == "IN_PLAY"
        {
            cell.differentiator.text = "-"
            cell.home.text = String(object.objectData[indexPath.section].homeGoals[indexPath.row]!)
            cell.away.text = String(object.objectData[indexPath.section].awayGoals[indexPath.row]!)
        }
        else
        {
            let s = object.objectData[indexPath.section].date[indexPath.row]
            cell.home.text = String(s[s.index(s.startIndex, offsetBy: 11)...s.index(s.startIndex, offsetBy: 12)])
            cell.away.text = String(s[s.index(s.startIndex, offsetBy: 14)...s.index(s.startIndex, offsetBy: 15)])
            cell.differentiator.text = ":"
        }
        return cell
        
    }
}
