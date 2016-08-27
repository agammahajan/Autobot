//
//  DetailViewController.swift
//  Autobot
//
//  Created by Agam Mahajan on 27/08/16.
//  Copyright © 2016 Agam Mahajan. All rights reserved.
//

import Foundation
import UIKit


var idDetail: String?
var statusDetail: String?
var projectDetail: String?
var testsuiteDetail: String?
var passedDetail: String?
var failedDetail: String?
var timetakenDetail: String?
var testDetail: String?
var createdbyDetail: String?
var createdatDetail: String?
var picDetail: String?
var uuidDetail: String?

class DetailViewController : UIViewController {
    
    

    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var testsuiteLabel: UILabel!
    @IBOutlet weak var passedLabel: UILabel!
    @IBOutlet weak var failedLabel: UILabel!
    @IBOutlet weak var timetakenLabel: UILabel!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var createdbyLabel: UILabel!
    @IBOutlet weak var createdatLabel: UILabel!
    @IBOutlet weak var reports: UIButton!
    
    @IBAction func clickReports(sender: AnyObject) {
        let url = "https://dev-tab-steller.s3-ap-southeast-1.amazonaws.com/" + uuidDetail! + "/report.html"
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idLabel.text = idDetail
        //statusLabel.text = statusDetail
        projectLabel.text = projectDetail
        testsuiteLabel.text = projectDetail
        passedLabel.text = "\(passedDetail!)" + " passed"
        failedLabel.text = "\(failedDetail!)" + " failed"
        
        if timetakenDetail == "" {
           timetakenLabel.text = "nil"
           reports.hidden = true
        }
        else{
           timetakenLabel.text = timetakenDetail
            reports.hidden = false
        }
        
        testLabel.text = testDetail
        createdatLabel.text = createdatDetail
        //createdbyLabel.text = createdbyDetail
        let url = NSURL(string: picDetail!)
        pic.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Placeholder"))
        pic.layer.cornerRadius = pic.frame.size.width / 2;
        pic.clipsToBounds = true
        
        let status:Int = Int(statusDetail!)!
        let failedNumber:Int = Int((failedDetail)!)!
        
        switch status {
        case 0 : statusLabel.text = "Added"
        statusLabel.textColor = UIColor(netHex:0x777777)
            break
        case 1 : statusLabel.text = "Running"
        statusLabel.textColor = UIColor(netHex:0x5BC0DE)
            break
        case 2 : statusLabel.text = "Aborted"
        statusLabel.textColor = UIColor(netHex:0xD9534F)
            break
        case 3 : statusLabel.text = "Killed"
        statusLabel.textColor = UIColor(netHex:0xD9534F)
            break
        case 4 : if failedNumber == 0 {
            statusLabel.text = "Success"
            statusLabel.textColor = UIColor(netHex:0x5CB85C)
        }
        else{
            statusLabel.text = "Failed"
            statusLabel.textColor = UIColor(netHex:0xD9534F)
        }
            break
        case 5 : statusLabel.text = "Killing"
        statusLabel.textColor = UIColor(netHex:0xF0AD4E)
            break
        case 6 : statusLabel.text = "Queued"
        statusLabel.textColor = UIColor(netHex:0x5BC0DE)
            break
        default : statusLabel.text = "Failed"
        statusLabel.textColor = UIColor(netHex:0xD9534F)
        }
        
        let email = createdbyDetail
        let temp = email!.componentsSeparatedByString("@")
        let fullNameArr: String = temp[0]
        createdbyLabel.text = fullNameArr.uppercaseFirst
        
        
    }
    
    
    
}