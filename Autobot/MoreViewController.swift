//
//  MoreViewController.swift
//  Autobot
//
//  Created by Agam Mahajan on 22/08/16.
//  Copyright © 2016 Agam Mahajan. All rights reserved.
//

import Foundation
import UIKit

class MoreViewController : UIViewController {
    
    //signed user details
    var UserName: String?
    var UserEmail: String?
    var UserPic: String?

    
    
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var SignOut: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        
    }
    
    func setView(){
        //Getting defaults
        let defaults = NSUserDefaults.standardUserDefaults()
       
        UserName = defaults.stringForKey("NameKey")
        print(UserName!)
        Name.text = UserName!
        
        UserEmail = defaults.stringForKey("EmailKey")
        print(UserEmail!)
        email.text = UserEmail!
        
        UserPic = defaults.stringForKey("PicKey")
        print(UserPic!)
        let url:NSURL = NSURL(string: UserPic!)!
        pic.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Placeholder"))
        pic.layer.cornerRadius = pic.frame.size.width / 2;
        pic.clipsToBounds = true
        
        
    }
    
    
    
    @IBAction func didTapSignOut(sender: AnyObject) {
        
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .ActionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "NO", style: .Cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Yes", style: .Default)
        { action -> Void in
            print("Yes")
            
            dispatch_async(dispatch_get_main_queue(),{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let temp = storyBoard.instantiateViewControllerWithIdentifier("ViewController") as UIViewController
            self.presentViewController(temp, animated:true, completion:nil)
            
              }
           )
            
            MainView.deleteDB()
            
            //changing Defaults to stop auto refresh
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "Signed")
            GIDSignIn.sharedInstance().signOut()
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
   
        self.presentViewController(actionSheetControllerIOS8, animated: true, completion: nil)


    }
    
}