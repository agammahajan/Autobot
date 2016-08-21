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

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Optimus_Prime.png")!)
//        backgroundImage.image = UIImage(named: "Optimus_Prime.png")
        labelView.backgroundColor = UIColor(white: 1, alpha: 0.2)
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    
    

}

