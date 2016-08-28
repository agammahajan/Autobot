//
//  SplashViewController.swift
//  Autobot
//
//  Created by Agam Mahajan on 19/08/16.
//  Copyright © 2016 Agam Mahajan. All rights reserved.
//

import Foundation
import UIKit

class SplashViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(SplashViewController.check), userInfo: nil, repeats: false)
        
    }
    
    func check(){
        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            //already Signed
            //Go to main view
            MoveToNextView("TabView")
        }
        else{
            //Go to login screen
            MoveToNextView("ViewController")
        }
    }
    
    func MoveToNextView(view: String){
        //Go to next view
        dispatch_async(dispatch_get_main_queue(),{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let temp = storyBoard.instantiateViewControllerWithIdentifier(view) as UIViewController
            self.presentViewController(temp, animated:true, completion:nil)
            
            }
        )
        
    }
    
    
}