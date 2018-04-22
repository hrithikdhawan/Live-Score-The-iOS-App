//
//  StandingViewController.swift
//  Live Score
//
//  Created by Siddharth Dhawan on 07/03/18.
//  Copyright © 2018 Siddharth Dhawan. All rights reserved.
//

import UIKit

class RowCell : UITableViewCell
{
    
    @IBOutlet var Pos: UILabel!
    @IBOutlet var Team: UILabel!
    @IBOutlet var GP: UILabel!
    @IBOutlet var Pts: UILabel!
    @IBOutlet var Goals: UILabel!
    @IBOutlet var GA: UILabel!
    @IBOutlet var W: UILabel!
    @IBOutlet var L: UILabel!
    @IBOutlet var D: UILabel!
}

class StandingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var mTableView: UITableView!
    var rowCount = 0
    var id = 445
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    var object: LeagueTable = LeagueTable()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head = tableView.dequeueReusableCell(withIdentifier: "header") as! RowCell
        head.D.text = "D"
        head.W.text = "W"
         head.L.text = "L"
         head.Pos.text = "Pos"
         head.Team.text = "Team"
         head.GP.text = "GP"
         head.Pts.text = "Pts"
         head.Goals.text = "Goals"
         head.GA.text = "GA"
        return head.contentView
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let obj = LeagueTable()
        rowCount = obj.leagueResult(id: id)
        object = obj
        mTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! RowCell
        cell.D.text = String(object.stand[indexPath.row].draws)
        cell.GA.text = String(object.stand[indexPath.row].goalsAgainst)
        cell.Goals.text = String(object.stand[indexPath.row].goals)
        cell.GP.text = String(object.stand[indexPath.row].playedGame)
        cell.W.text = String(object.stand[indexPath.row].wins)
        cell.L.text = String(object.stand[indexPath.row].loses)
        cell.Pos.text = String(object.stand[indexPath.row].position)
        cell.Pts.text = String(object.stand[indexPath.row].points)
        cell.Team.text = object.stand[indexPath.row].teamsName
        return cell
    }
    
}
