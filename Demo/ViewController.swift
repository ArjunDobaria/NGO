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

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    

    @IBOutlet weak var googlebtn: GIDSignInButton!
    @IBOutlet weak var facebookbtn: LoginButton!
    var isLoggin : Bool = false
    var dict : [String : AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var error : NSError?

        GGLContext.sharedInstance().configureWithError(&error)

        if error != nil{
            print(error ?? "google error")
            return
        }

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        facebookbtn = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
    }
    
    
    //function is fetching the user data
    func getFBUserData(){
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    UserDefaults.standard.set(true, forKey: "isUserLogin")
                    UserDefaults.standard.synchronize()
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
        
        UserDefaults.standard.set(true, forKey: "isUserLogin")
        UserDefaults.standard.synchronize()
        AppDelegate().sharedDelegate().DashbordCall()
    }
    
    @IBAction func googlebtn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func facebookbtn(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions : [ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
//            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            case .success:
                self.getFBUserData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}



