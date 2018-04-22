//
//  ViewController.swift
//  Live Score
//
//  Created by Siddharth Dhawan on 31/01/18.
//  Copyright © 2018 Siddharth Dhawan. All rights reserved.
//

import UIKit
class FirstViewController: UIViewController
{
    var hiddenMenu = false
    @IBOutlet var hiddenContainerView: UIView!
    @IBAction func displayMenu(_ sender: UIBarButtonItem)
    {
        self.hiddenContainerView.isHidden = !self.hiddenContainerView.isHidden
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
class MenuViewController : UITableViewController
{
    let SportsList = ["Football" ,"Cricket","Basketball"]
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SportsList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel?.text = SportsList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        //let parent = storyboard?.instantiateViewController(withIdentifier: "FootballViewController")
        if index == 0
        {
            
        }
        else
        {
            performSegue(withIdentifier: "cricketSegue", sender: nil)
        }
        
    }
}


