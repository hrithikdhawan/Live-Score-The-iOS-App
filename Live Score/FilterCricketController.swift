//
//  FilterCricketController.swift
//  Live Score
//
//  Created by Siddharth Dhawan on 05/04/18.
//  Copyright © 2018 Siddharth Dhawan. All rights reserved.
//

import UIKit

class CustomFilterCell : UITableViewCell
{
    @IBOutlet var matchType: UILabel!
    @IBOutlet var switchOn: UISwitch!
    
}
class FilterCricketController: UIViewController ,UITableViewDelegate, UITableViewDataSource
{
    let match = ["List A","First Class","Women's ODI","ODI","Twenty 20"]
    var switchOn = [Bool](repeating: true, count: 5)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return match.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filtercell") as! CustomFilterCell
        cell.matchType.text = match[indexPath.row]
        cell.switchOn.tag = indexPath.row
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switchOn[indexPath.row] = true
    }
     func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switchOn[indexPath.row] = false
    }
    @IBAction func switchChange(_ sender: UISwitch)
    {
        let tag = sender.tag
        if sender.isSelected
        {
            switchOn[tag] = true
        }
        else
        {
            switchOn[tag] = false
        }
    }
    @IBAction func filterExit(_ sender: UIBarButtonItem) {
       CricketScoreController().setIncluded(included: switchOn)
        //let selectedItems :[String : [Bool]] = ["match" : switchOn]
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue : "filter"), object: nil, userInfo: selectedItems)
        performSegue(withIdentifier: "filterDone", sender: nil)
        
    }
}
