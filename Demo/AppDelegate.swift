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
import FBSDKCoreKit
import GooglePlaces
import GoogleMaps
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var isLoggin : Bool = false
//    var center = UNUserNotificationCenter.current()
  
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         UserDefaults.standard.set("", forKey: "url")
        
//        let options: UNAuthorizationOptions = [.alert, .sound]
//        
//        center.requestAuthorization(options: options) {
//            (granted, error) in
//            if !granted {
//                print("Something went wrong")
//            }
//        }
//        
//        center.getNotificationSettings { (settings) in
//            if settings.authorizationStatus != .authorized {
//                // Notifications not allowed
//            }
//        }
        
        if(UserDefaults.standard.bool(forKey: "isUserLogin"))
        {
            isLoggin = true
            DashbordCall()
        }
        
        GMSPlacesClient.provideAPIKey("AIzaSyDkWnLbjYJfbRs5tU5Uen2FzEXe0g8W4Ag")
        GMSServices.provideAPIKey("AIzaSyDkWnLbjYJfbRs5tU5Uen2FzEXe0g8W4Ag")
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        
        let isFacebookURL = url.scheme != nil && url.scheme!.hasPrefix("fb\(FBSDKSettings.appID())") && url.host == "authorize"
        if isFacebookURL {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return false
        
        
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL!,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
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

//    func applicationWillResignActive(_ application: UIApplication) {
//        FBSDKAppEvents.activateApp()
//    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
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
        if isLoggin {
            rootNav.pushViewController(menuContainer, animated: false)
        }
        else {
            rootNav.pushViewController(menuContainer, animated: true)
        }
    }

    func encodeDictionaryToString(_ dictionary: NSMutableDictionary) -> String {
        let parts:NSMutableArray = NSMutableArray()
        
        for (key, value) in dictionary {
            var keyName:String = ""
            var keyValue:String = ""
            if let _ = value as? String {
                keyName = key as! String
                keyValue = value as! String
            } else if let _ = value as? Int {
                keyName = key as! String
                keyValue = String(format: "%u", (value as AnyObject).doubleValue)
            }
            let part:NSString = String(format: "%@=%@", keyName,keyValue) as NSString
            parts.add(part)
        }
        let encodedDictionary:NSString = parts.componentsJoined(by: "&") as NSString;
        return encodedDictionary as String
    }
    
}

//class UYLNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        // Play sound and show alert to the user
//        completionHandler([.alert,.sound])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        // Determine the user action
//        switch response.actionIdentifier {
//        case UNNotificationDismissActionIdentifier:
//            print("Dismiss Action")
//        case UNNotificationDefaultActionIdentifier:
//            print("Default")
//        case "Snooze":
//            print("Snooze")
//        case "Delete":
//            print("Delete")
//        default:
//            print("Unknown action")
//        }
//        completionHandler()
//    }
//}

