//
//  AppDelegate.swift
//  Autobot
//
//  Created by Agam Mahajan on 16/08/16.
//  Copyright © 2016 Agam Mahajan. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var token: String?
    var givenName: String?
    var loginViewController: ViewController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
       

        
        // Override point for customization after application launch.
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
//        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
//            //silent sign in
//            //            GIDSignIn.sharedInstance().signInSilently()
//            //Go to next view
//            self.MoveToNextView()
//        }
//        else{
//            print("New User")
//        }
        
        return true
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        
//        The method should call the handleURL method of the GIDSignIn instance, which will properly handle
//        the URL that your application receives at the end of the authentication process.
        
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }
    
    
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
//    For your app to run on iOS 8 and older, also implement the deprecated
        
        var options: [String: AnyObject] = [UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication!,
                                            UIApplicationOpenURLOptionsAnnotationKey: annotation!]
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        
        loginViewController.progressBarDisplayer("Signing in", true)
        
        if (error == nil) {
            // Perform any operations on signed in user here.
        
            GetToken(user)
           
        } else {
            print("\(error.localizedDescription)")
            loginViewController.messageFrame.hidden = true
        }
    }
    
    func GetToken(user: GIDGoogleUser!) {
//        let userId = user.userID                  // For client-side use only!
//        let fullName = user.profile.name
          givenName = user.profile.givenName
//        let familyName = user.profile.familyName
        let email = user.profile.email
        let idToken = user.authentication.idToken // Safe to send to the server
        
        //print(idToken)
        print(email)
        let url:NSURL = NSURL(string: "https://autobot.practodev.com/api/v1/getSessionToken")!
        
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        let paramString = "code=\(idToken)"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        Request(request)
        
        
    }
    
    func Request(request: NSMutableURLRequest) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            data, response,  error in
            
            if error != nil {
                print("error=\(error)")
                self.loginViewController.messageFrame.hidden = true
                return
            }
            //print(response)
            let httpResponse = response as? NSHTTPURLResponse
            let StatusCode = httpResponse?.statusCode
            //print(StatusCode)
            if (StatusCode)! == 200 {
                //let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                //print(dataString!)
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    self.token = json["api_token"] as? String
                
                    print(self.token!)
                    
                    //Setting Defaults
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(self.token, forKey: "TokenKey")
                    defaults.setObject(self.givenName, forKey: "NameKey")
                    defaults.setBool(true, forKey: "Signed")
                    
                    
                    //Go to next view
                   self.MoveToNextView("TabView")
                    
                    
                } catch let error as NSError {
                    print("json error: \(error.localizedDescription)")
                    
                }
            }
            else if (StatusCode)! == 401 {
                print("Only practo users are allowed to access")
                self.MoveToNextView("ViewController")
                
                
                
                
                GIDSignIn.sharedInstance().signOut()
                
                
            }
            else {
                print("Dont know")
                self.loginViewController.messageFrame.hidden = true
                GIDSignIn.sharedInstance().signOut()
            }
        }
        
        task.resume()
    }
    
    func MoveToNextView(view: String){
        //Go to next view
        dispatch_async(dispatch_get_main_queue(),{
            let board = UIStoryboard(name: "Main" , bundle: nil)
            let tempView = board.instantiateViewControllerWithIdentifier(view)
            
            self.window!.rootViewController = tempView
            
            }
        )
        
        if view == "ViewController" {
            dispatch_async(dispatch_get_main_queue(), {
                let alert = UIAlertController(title: "Alert", message: "Only practo users are allowed to access", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
                self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                }
            )
        }

    }
    
 


}

