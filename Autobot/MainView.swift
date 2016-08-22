//
//  MainView.swift
//  Autobot
//
//  Created by Agam Mahajan on 17/08/16.
//  Copyright © 2016 Agam Mahajan. All rights reserved.
//

import Foundation
import UIKit



// for capitalising the name
extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercaseString + String(characters.dropFirst())
    }
}


class MainView : UITableViewController {
    
    var convertedJsonIntoDict: NSDictionary!
    var items = [AnyObject]()
    var item: NSDictionary?
    var url: NSURL!
    var Token: String?
    

    
    
    
    //for loading indicator
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 10 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.5)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }

 
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (items.count)
        
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section \(section)"
//    }
//    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as! JobTableViewCell
      
        item = items[indexPath.row] as? NSDictionary
        if item != nil {
            //cell.idLabel.text = "\(item!["id"]!)"
            cell.runFailedLabel.text = "\(item!["runFailed"]!)"
            cell.projectNameLabel.text = "\(item!["id"]!)" + "(\(item!["projectName"]!))"
            cell.passedLabel.text = "\(item!["passed"]!) passed"
            cell.failedLabel.text = "\(item!["failed"]!) failed"
            
            let email = "\(item!["email"]!)"
            let temp = email.componentsSeparatedByString("@")
            let fullNameArr: String = temp[0]
            cell.emailLabel.text = fullNameArr.uppercaseFirst
            url = NSURL(string: "\(item!["picture"] == nil ? "" : item!["picture"]!)")
//
            cell.profilePic.sd_setImageWithURL(url)
            cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
            cell.profilePic.clipsToBounds = true
            
            //hide activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            
        }
        messageFrame.hidden = true
        
        return cell
    }
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageFrame.hidden = false
        progressBarDisplayer("Fetching Jobs", true)
        
        
        
        //Pull to refresh
        self.refreshControl?.addTarget(self, action: #selector(MainView.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        //Auto Refresh
        _ = NSTimer.scheduledTimerWithTimeInterval(120, target: self, selector: #selector(MainView.update), userInfo: nil, repeats: true)
        
        //Getting defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        Token = defaults.stringForKey("TokenKey")
            print(Token!)
       
        
        
        Request()
        
    }
    
    func Request() {
        
        let url:NSURL = NSURL(string: "https://autobot.practodev.com/api/v1/jobs?limit=10")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue(Token!, forHTTPHeaderField: "apiToken")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            data, response,  error in
            
            if error != nil {
                print("error=\(error)")
                
                return
            }
            // Convert server json response to NSDictionary
            do {
                  self.convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                    
                    // Print out dictionary
                    //print(self.convertedJsonIntoDict)
                
                    self.items = self.convertedJsonIntoDict!["jobs"] as! [AnyObject]
                    //print(self.items[0]["id"])
                print("Data Fetched")
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
               
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func refresh(sender:AnyObject){
        //pull to Refresh
        print("Refresh")
        Request()
        self.refreshControl?.endRefreshing()
    }
    
    func update() {
        //show activity indicator
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let temp = defaults.boolForKey("Signed")
        if temp == true {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            print("AutoRefresh!")
            Request()
        }
        
    }
    
}
