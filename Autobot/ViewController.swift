//
//  ViewController.swift
//  Autobot
//
//  Created by Agam Mahajan on 16/08/16.
//  Copyright © 2016 Agam Mahajan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var backgroundImage: UIImageView!
   
    @IBOutlet weak var labelView: UIView!
    
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY + 50 , width: 180, height: 50))
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Optimus_Prime.png")!)
//        backgroundImage.image = UIImage(named: "Optimus_Prime.png")
        labelView.backgroundColor = UIColor(white: 1, alpha: 0.2)
//        progressBarDisplayer("Signing in", false)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.loginViewController = self
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    
    

}

