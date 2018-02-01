//
//  ViewController.swift
//  Demo
//
//  Created by lanet on 15/01/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit
import Foundation
import GoogleSignIn
import Google
import FacebookLogin
import FBSDKLoginKit
import Alamofire
import UserNotifications


class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate {
    

    @IBOutlet weak var googlebtn: GIDSignInButton!
    @IBOutlet weak var facebookbtn: LoginButton!
    var isLoggin : Bool = false
    var dict : [String : AnyObject]!
    var Googledict : [String : AnyObject]!
//    var center = UNUserNotificationCenter.current()
//    let notificationDelegate = UYLNotificationDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UNUserNotificationCenter.current().delegate = self
        var error : NSError?

        GGLContext.sharedInstance().configureWithError(&error)

        if error != nil{
            print(error ?? "google error")
            return
        }
        
        if let accessToken = FBSDKAccessToken.current() {
            print(accessToken)
        }

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        facebookbtn = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert])
//    }
    // MARK: - Private Methods
//    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
//        // Request Authorization
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
//            if let error = error {
//                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
//            }
//
//            completionHandler(success)
//        }
//    }
    
//    private func scheduleLocalNotification() {
//        // Create Notification Content
//        let notificationContent = UNMutableNotificationContent()
//
//        // Configure Notification Content
//        notificationContent.title = "This is From Demo"
//        notificationContent.subtitle = "Local Notifications"
//        notificationContent.badge = 1
//        notificationContent.body = "This application is about to give some amout from your food bill to the NGO trusts."
//
//        // Add Trigger
//        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
//
//        // Create Notification Request
//        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
//
//        // Add Request to User Notification Center
//        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
//            if let error = error {
//                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
//            }
//        }
//    }
//
//    @IBAction func pressHerebtn(_ sender: Any) {
//
//        // Request Notification Settings
//        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
//            switch notificationSettings.authorizationStatus {
//            case .notDetermined:
//                self.requestAuthorization(completionHandler: { (success) in
//                    guard success else { return }
//
//                    // Schedule Local Notification
//                })
//            case .authorized:
//                self.scheduleLocalNotification()
//            case .denied:
//                print("Application Not Allowed to Display Notifications")
//            }
//        }
//    }
    
    
    //function is fetching the user data
    func getFBUserData(){
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(self.dict)
                    UserDefaults.standard.set("fb", forKey: "login")
                    UserDefaults.standard.set(true, forKey: "isUserLogin")
                    UserDefaults.standard.synchronize()

                    APIManager.sharedInstance.servicePost("http://localhost:3000/register", param: ["email" : self.dict["name"]!], headerParam: [:], successBlock:
                        {(response) in
                            print(response)
                    }, failureBlock:
                        {(error) in
                            print(error)
                    })
                    AppDelegate().sharedDelegate().DashbordCall()
                }
            })
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        if error != nil{
            print(error ?? "google error")
            return
        }
        
        print("User Id = " , user.userID)                  // For client-side use only!
        print("idToken = " , user.authentication.idToken) // Safe to send to the server
        print("User name = " , user.profile.name)
        print("givenName = " , user.profile.givenName)
        print("familyName = " , user.profile.familyName)
        print("email = " , user.profile.email)
        UserDefaults.standard.set("gp", forKey: "login")
        UserDefaults.standard.set(true, forKey: "isUserLogin")
        UserDefaults.standard.synchronize()
        
        APIManager.sharedInstance.servicePost("http://localhost:3000/register", param: ["email" : user.profile.email], headerParam: [:], successBlock:
            {(response) in
                print(response)
        }, failureBlock:
            {(error) in
                print(error)
        })
        
        AppDelegate().sharedDelegate().DashbordCall()
    }
    
    @IBAction func googlebtn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func facebookbtn(_ sender: Any) {
//        let loginManager = LoginManager()
//        loginManager.logIn(readPermissions : [ .publicProfile, .email, .userLocation ], viewController: self) { loginResult in
//            switch loginResult {
//            case .failed(let error):
//                print(error)
//            case .cancelled:
//                print("User cancelled login.")
////            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
//            case .success:
//                self.getFBUserData()
//            }
//        }
        
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions : [ .publicProfile, .email, .userLocation ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                self.getFBUserData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



