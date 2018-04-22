//
//  HomeViewController.swift
//  Live Score
//
//  Created by Siddharth Dhawan on 10/04/18.
//  Copyright © 2018 Siddharth Dhawan. All rights reserved.
//

import UIKit

class HomeViewController : UITableViewController
{
    @IBOutlet var footballImage: UIImageView!
     var dateFormator = DateFormatter()
    var sports : [String : String] = ["type" : "ipl"]
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormator.timeZone = TimeZone(abbreviation: "GMT+5:30")
        dateFormator.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
       
        
        footballImage.animationImages = [
            UIImage(named: "premierleague.jpeg")!,
            UIImage(named: "russia.jpeg")!,
            UIImage(named: "worldcup.png")!,
            UIImage(named: "fifa18.jpg")!,
        ]
        footballImage.animationDuration = 5
        footballImage.startAnimating()
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2
        {
            News().set(sp: "nba")
        }
    }
    @IBAction func footallnews(_ sender: UIButton)
    {
         News().set(sp: "premier+league")
        
    }
    @IBAction func cricketnews(_ sender: UIButton)
    {
        
        News().set(sp: "ipl")
        
    }
    
    @IBAction func basketballnews(_ sender: UIButton)
    {
        News().set(sp: "nba")

    }
}
