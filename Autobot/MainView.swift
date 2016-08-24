//
//  MainView.swift
//  Autobot
//
//  Created by Agam Mahajan on 17/08/16.
//  Copyright © 2016 Agam Mahajan. All rights reserved.
//

import Foundation
import UIKit
import CoreData


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
    var jobsDB: [Jobs]?
    var item: NSDictionary?
    var iterator: Jobs? = nil
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
        return jobsDB?.count ?? 0
        
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section \(section)"
//    }
//    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as! JobTableViewCell

        iterator = jobsDB?[indexPath.row]
        if iterator != nil {
            cell.runFailedLabel.text = iterator?.run_failed
            cell.projectNameLabel.text = (iterator?.id)! + "(\((iterator?.project_name)!))"
            cell.passedLabel.text = (iterator?.passed)! + " passed"
            cell.failedLabel.text = (iterator?.failed)! + " failed"
            
            let email = iterator?.email
            let temp = email!.componentsSeparatedByString("@")
            let fullNameArr: String = temp[0]
            cell.emailLabel.text = fullNameArr.uppercaseFirst
            url = NSURL(string: (iterator?.picture)!)
            
            cell.profilePic.sd_setImageWithURL(url, placeholderImage: UIImage(named: "HomeScreen"))
            cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
            cell.profilePic.clipsToBounds = true
        }
      
        messageFrame.hidden = true
        
        return cell
    }
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetch()
        
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
                
                self.fetch()
                
                return
            }
            // Convert server json response to NSDictionary
            do {
                self.convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                
                self.items = self.convertedJsonIntoDict!["jobs"] as! [AnyObject]
                print("Data fetched from api")
                
                self.delete()
                self.save_data(self.items)
                self.fetch()
                
                //hide activity indicator
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
               
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
        //show activity indicator and auto refresh
        let defaults = NSUserDefaults.standardUserDefaults()
        let temp = defaults.boolForKey("Signed")
        if temp == true {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            print("AutoRefresh!")
            Request()
        }
        
    }
    
    
    func save_data(items: AnyObject){
        // create an instance of our managedObjectContext
        let moc = DataController.sharedInstance.managedObjectContext
        
        // we set up our entity by selecting the entity and context that we're targeting
        
        // add our data
        
        
            for index in 0...9 {
                self.item = items[index] as? NSDictionary
                if self.item != nil {
                    if let entity = NSEntityDescription.insertNewObjectForEntityForName("Jobs", inManagedObjectContext: moc) as? Jobs{
                        entity.setValue("\(self.item!["projectName"]!)", forKey: "project_name")
                        entity.setValue("\(self.item!["id"]!)", forKey: "id")
                        entity.setValue("\(self.item!["runFailed"]!)", forKey: "run_failed")
                        entity.setValue("\(self.item!["passed"]!)", forKey: "passed")
                        entity.setValue("\(self.item!["failed"]!)", forKey: "failed")
                        entity.setValue("\(self.item!["email"]!)", forKey: "email")
                        entity.setValue("\(self.item!["picture"]!)", forKey: "picture")
                    }
                }
            
            do {
                try moc.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
        
        // we save our entity
        print("Data Saved")

    }
    
    
    func fetch() {
        let moc = DataController.sharedInstance.managedObjectContext
        let Fetch = NSFetchRequest(entityName: "Jobs")
        
        do {
            if let fetchedJobs = try moc.executeFetchRequest(Fetch) as? [Jobs] where fetchedJobs.count > 0{
            
            
             jobsDB = fetchedJobs
             dispatch_async(dispatch_get_main_queue(), {

                    self.tableView.reloadData()
               })
            }
           print("Data fetched from DB")
        } catch {
            fatalError("Failed to fetch jobs: \(error)")
        }
    }
    
    func delete(){
        let moc = DataController.sharedInstance.managedObjectContext
        let ReqVar = NSFetchRequest(entityName: "Jobs")
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do {
            try moc.executeRequest(DelAllReqVar)
            print("Data deleted from DB")
        }
        catch {
            fatalError("Failed to delete jobs: \(error)")
        }
    }
}
