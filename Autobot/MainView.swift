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


 // MARK: Extension
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
 
 extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
 }

//MARK: MainView
class MainView : UITableViewController , NSFetchedResultsControllerDelegate , UISearchResultsUpdating , UISearchBarDelegate {
    
    var convertedJsonIntoDict: NSDictionary!
    var items = [AnyObject]()
//    var jobsDB: [Jobs] = []
//    var item: NSDictionary?
    var iterator: Jobs? = nil
    var url: NSURL!
    var Token: String?
    var iter: AnyObject?
    var limit: Int!
    
    var fetchedResultsController: NSFetchedResultsController?

    var searchController: UISearchController!
    var showSearchResuts: Bool = false
    var filteredJobs: [Jobs] = []
    
    //for loading indicator
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    // MARK: SearchBAR
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        showSearchResuts = true
        self.fetchedResultsController?.delegate = nil
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        showSearchResuts = false
        tableView.reloadData()
        self.fetchedResultsController?.delegate = self
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !showSearchResuts {
            showSearchResuts = true
            tableView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
        self.fetchedResultsController?.delegate = self
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
//        filteredJobs = (fetchedResultsController?.fetchedObjects as! [Jobs]).filter({ (job) -> Bool in
//            if searchString == "" {
//                return true
//            }
//            return (job.id?.rangeOfString(searchString! , options: NSStringCompareOptions.CaseInsensitiveSearch)) != nil
//        })
        let moc = DataController.sharedInstance.managedObjectContext
        let Fetchrequest = NSFetchRequest(entityName: "Jobs")
         Fetchrequest.predicate = NSPredicate(format: "id CONTAINS[c] %@ OR email CONTAINS[c] %@ OR project_name CONTAINS[c] %@", searchString!, searchString!,searchString!)
        do {
            if let fetchedJobs = try moc.executeFetchRequest(Fetchrequest) as? [Jobs] {
                filteredJobs = fetchedJobs
            }
            
        }
        catch {
            fatalError("Failure to fetch context: \(error)")
        }

        
        tableView.reloadData()
    }
    func configureSearchController(){
        
        searchController = UISearchController(searchResultsController: nil)
        self.extendedLayoutIncludesOpaqueBars = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search a Project"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        self.definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView(frame: CGRectZero)
        searchController.hidesNavigationBarDuringPresentation = true
//        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    // MARK: Activity Indicator
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90 , y: view.frame.midY - 70   , width: 180, height: 50))
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

 
    // MARK: Populate Table
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showSearchResuts == true {
            return filteredJobs.count
        }
        if fetchedResultsController != nil {
            
            return (fetchedResultsController!.sections?[section].numberOfObjects)!
        }
            return 0
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section \(section)"
//    }
//    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as! JobTableViewCell

        iterator = (showSearchResuts ? filteredJobs[indexPath.row] : fetchedResultsController!.objectAtIndexPath(indexPath) )as? Jobs
        if iterator != nil {
            cell.projectNameLabel.text = (iterator?.id)! + "(\((iterator?.project_name)!))"
            cell.passedLabel.text = (iterator?.passed)! + " passed"
            cell.failedLabel.text = (iterator?.failed)! + " failed"
            
            let status:Int = Int((iterator?.run_failed)!)!
            let failedNumber:Int = Int((iterator?.failed)!)!
            
            switch status {
            case 0 : cell.runFailedLabel.text = "Added"
            cell.runFailedLabel.textColor = UIColor(netHex:0x777777)
                break
            case 1 : cell.runFailedLabel.text = "Running"
            cell.runFailedLabel.textColor = UIColor(netHex:0x5BC0DE)
                break
            case 2 : cell.runFailedLabel.text = "Aborted"
            cell.runFailedLabel.textColor = UIColor(netHex:0xD9534F)
                break
            case 3 : cell.runFailedLabel.text = "Killed"
            cell.runFailedLabel.textColor = UIColor(netHex:0xD9534F)
                break
            case 4 : if failedNumber == 0 {
                cell.runFailedLabel.text = "Success"
                cell.runFailedLabel.textColor = UIColor(netHex:0x5CB85C)
            }
            else{
                cell.runFailedLabel.text = "Failed"
                cell.runFailedLabel.textColor = UIColor(netHex:0xD9534F)
            }
                break
            case 5 : cell.runFailedLabel.text = "Killing"
            cell.runFailedLabel.textColor = UIColor(netHex:0xF0AD4E)
                break
            case 6 : cell.runFailedLabel.text = "Queued"
            cell.runFailedLabel.textColor = UIColor(netHex:0x5BC0DE)
                break
            default : cell.runFailedLabel.text = "Failed"
            cell.runFailedLabel.textColor = UIColor(netHex:0xD9534F)
            }
            
            let email = iterator?.email
            let temp = email!.componentsSeparatedByString("@")
            let fullNameArr: String = temp[0]
            cell.emailLabel.text = fullNameArr.uppercaseFirst
            url = NSURL(string: (iterator?.picture)!)
            cell.profilePic.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Placeholder"))
            cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
            cell.profilePic.clipsToBounds = true
        }
      
        messageFrame.hidden = true
        return cell
    }
    
    
   // MARK: View disappears
    override func viewWillDisappear(animated: Bool) {
//        //changing Defaults to stop auto refresh
//        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setBool(false, forKey: "Signed")
        
    }
   
    
    // MARK: ViewLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        
        defaults.setBool(true, forKey: "Signed")
        Token = defaults.stringForKey("TokenKey")
        
        //fetch()
        self.fetch_new()
        
        self.messageFrame.hidden = false
        progressBarDisplayer("Fetching Jobs", true)
        
        //Pull to refresh
        self.refreshControl?.addTarget(self, action: #selector(MainView.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        //Auto Refresh
        _ = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: #selector(MainView.update), userInfo: nil, repeats: true)
        
        
    
        
        
        Request()
    }
    
    func Request() {
        
        let count = calCount()
        if count == 0 {
            limit = 100
        }
        else{
            limit = count
        }
        print(limit)
        let api = "https://autobot.practodev.com/api/v1/jobs?limit=" + "\(limit)"
        let url:NSURL = NSURL(string: api)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue(Token!, forHTTPHeaderField: "apiToken")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            data, response,  error in
            
            //When there is no internet
            if error != nil {
                print(error?.code)
                if error?.code == -1009{
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.messageFrame.hidden = true
                    dispatch_async(dispatch_get_main_queue(), {
                        let alert = UIAlertController(title: "No Internet Connection Found", message: "Connect to Internet to get Latest Jobs", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        }
                    )
                }
                return
            }
            // Convert server json response to NSDictionary
            do {
                self.convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                
                self.items = self.convertedJsonIntoDict!["jobs"] as! [AnyObject]
                print("Data fetched from api")
                
                
                self.save_data_new(self.items)

                //hide activity indicator
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
               
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    // MARK: Pull to Refresh
    func refresh(sender:AnyObject){
        //pull to Refresh
        if showSearchResuts == false {
            Request()
            print("Refresh")
        }
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: AutoRefresh
    func update() {
        //show activity indicator and auto refresh
        let defaults = NSUserDefaults.standardUserDefaults()
        let temp = defaults.boolForKey("Signed")
        if temp == true {
            if showSearchResuts == false {
                if Reachability.isConnectedToNetwork() == true {
                    print("Internet connection OK")
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    print("AutoRefresh!")
                    Request()
                } else {
                    print("Internet connection FAILED")
                }
            }
            
        }
        
    }
    
    // Calculate count in db
     func calCount() -> Int {
        let moc = DataController.sharedInstance.managedObjectContext
        let Fetch = NSFetchRequest(entityName: "Jobs")
        do {
            if let fetchedJobs = try moc.executeFetchRequest(Fetch) as? [Jobs] {
                return fetchedJobs.count
            }
            
        }
        catch {
            fatalError("Failure to fetch context: \(error)")
        }
        return 0
    }
    
    
    
    // MARK: Saving Data
    func save_data_new(items: [AnyObject]){
        let moc = DataController.sharedInstance.managedObjectContext
        
        for index in 0..<limit {
            iter = items[index]
            if iter != nil {
                let temp = iter!["id"]
                let Fetch = NSFetchRequest(entityName: "Jobs")
                Fetch.predicate = NSPredicate(format: "id = %@", temp!!.description)
                do {
                    if let fetchedJobs = try moc.executeFetchRequest(Fetch) as? [Jobs] where fetchedJobs.count > 0{
                    let managedObject = fetchedJobs[0]
                    managedObject.setValue("\(iter!["status"]!!)" ?? "", forKey: "run_failed")
                    managedObject.setValue("\(iter!["passed"]!!)" ?? "", forKey: "passed")
                    managedObject.setValue("\(iter!["failed"]!!)" ?? "", forKey: "failed")
                    }
                    else {
                        if let entity = NSEntityDescription.insertNewObjectForEntityForName("Jobs", inManagedObjectContext: moc) as? Jobs{
                            entity.setValue("\(iter!["projectName"]!!)" ?? "", forKey: "project_name")
                            entity.setValue("\(iter!["id"]!!)" ?? "", forKey: "id")
                            entity.setValue("\(iter!["status"]!!)" ?? "", forKey: "run_failed")
                            entity.setValue("\(iter!["passed"]!!)" ?? "", forKey: "passed")
                            entity.setValue("\(iter!["failed"]!!)" ?? "", forKey: "failed")
                            entity.setValue("\(iter!["email"]!!)" ?? "", forKey: "email")
                            entity.setValue("\(iter!["picture"]!!)" ?? "", forKey: "picture")
                        }
                    }
                    
                }
                catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
            do {
                try moc.save()
            }
            catch {
                fatalError("Failure to save context: \(error)")
            }
        }
        print("Data saved")
    }
    
    //MARK: FetchResultController
    
    func fetch_new() {
        let moc = DataController.sharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Jobs")
        let fetchSort = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [fetchSort]
        fetchRequest.fetchBatchSize = 10
//        fetchRequest.fetchLimit = 10
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController!.performFetch()
            
        } catch let error as NSError {
            print("Unable to perform fetch: \(error.localizedDescription)")
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        // 1
        switch type {
        case .Insert: 
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        
        default: break
        
        }
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        // 2
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)

        }
    }
    
    // MARK: Delete DB
        static func deleteDB() {
        let moc = DataController.sharedInstance.managedObjectContext
        let Fetch = NSFetchRequest(entityName: "Jobs")
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: Fetch)
        do {
            try moc.executeRequest(DelAllReqVar) }
        catch { print(error) }
    }
}
