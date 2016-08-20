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
        addBackgroundImage()
        let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(SplashViewController.check), userInfo: nil, repeats: false)
        
    }
    
    func addBackgroundImage(){
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let bg = UIImage(named: "Optimus_Prime.png")
        let bgView = UIImageView(image: bg)
        
        bgView.frame = CGRectMake(10, 10, screenSize.width, screenSize.height)
        self.view.addSubview(bgView)
    }
    
    func check(){
        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            //already Signed
            //Go to main view
            MoveToNextView("NavigationView")
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