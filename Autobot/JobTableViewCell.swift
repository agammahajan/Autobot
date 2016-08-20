//
//  JobTableViewCell.swift
//  Autobot
//
//  Created by Agam Mahajan on 18/08/16.
//  Copyright © 2016 Agam Mahajan. All rights reserved.
//


import UIKit
import Foundation

class JobTableViewCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var passedLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var failedLabel: UILabel!
    @IBOutlet weak var runFailedLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    
    
  
    
    //    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        return 1
    //    }
    //
    //    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return 10
    //    }
    //
    ////    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    ////        return "Section \(section)"
    ////    }
    //
    //    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath)
    //
    //
    //        cell.textLabel?.text = "Row \(indexPath.row)"
    //        
    //        return cell
    //    }
    

}
