//
//  AppDelegate.swift
//  Demo
//
//  Created by lanet on 15/01/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit
import Google
import MFSideMenu
import GoogleSignIn
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var isLoggin : Bool = false
   
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
        if(UserDefaults.standard.bool(forKey: "isUserLogin"))
        {
            isLoggin = true
            DashbordCall()
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    //Mark:- Set Storybord
    func storybord() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    //MARK: - sharedDelegate
    func sharedDelegate() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL!,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func DashbordCall(){
       
        let rootNav : UINavigationController = self.window?.rootViewController as! UINavigationController
        let navigationController:UINavigationController = storybord().instantiateViewController(withIdentifier: "ViewControllerVC")  as! UINavigationController
        let sideMenuVc : SideMenuViewController = storybord().instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        let menuContainer:MFSideMenuContainerViewController = MFSideMenuContainerViewController.container(withCenter: navigationController, leftMenuViewController: sideMenuVc, rightMenuViewController: nil)
        menuContainer.shadow.enabled = true
        menuContainer.panMode = MFSideMenuPanModeNone
        if isLoggin
        {
            rootNav.pushViewController(menuContainer, animated: false)
        }
        else
        {
            rootNav.pushViewController(menuContainer, animated: true)
        }

       
    }
    
//    storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let rootNavigationController:UINavigationController = self.window?.rootViewController as! UINavigationController
//    let navigationController:UINavigationController = storyboard.instantiateViewController(withIdentifier: "ViewControllerVC")  as! UINavigationController
//
//

}

