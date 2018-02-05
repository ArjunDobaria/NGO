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
import AudioToolbox
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var isLoggin : Bool = false
    @objc var headerView : UIView!
    var appName : UILabel!
     var body : UILabel!
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
              Fabric.with([Crashlytics.self])
         UserDefaults.standard.set("", forKey: "url")
        setCategories()
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            print("Not Available")
        }
        
        //Mark:- Local Notification
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

        //Mark:- Push Notification
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ granted, error in }
        } else { // iOS 9 support
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        }
        application.registerForRemoteNotifications()
        
        
        
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
    
    //Mark:- Push Notification Methods
  
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("success in registering for remote notifications with token \(deviceTokenString)")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        if application.applicationState == .active {
//            let aps = userInfo["aps"] as! [String : Any]
//            let imageURL = userInfo["data"] as! String
//            print(aps)
//            print(imageURL)
//            Banner(view: self.window!, data: userInfo)
//        }
//        else
//        {
            print("Received push notification: \(userInfo)")
            let aps = userInfo["aps"] as! [String: Any]
            print("\(aps)")
//        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "meow" {
            //Do something...
        }
        if response.actionIdentifier == "pizza" {
            //Do something else...
        }
        completionHandler()
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
        application.applicationIconBadgeNumber = 0
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
    
//    func Banner(view : UIView, data: [AnyHashable : Any])
//    {
//        let aps = data["aps"] as! [String : Any]
//        let img = data["data"] as! String
//        AudioServicesPlaySystemSound(SystemSoundID(1007))
//        headerView = UIView()
//
//        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/7)
//
//        headerView.backgroundColor = UIColor.black.withAlphaComponent(1.0)
//        view.addSubview(headerView)
//
//        appName = UILabel()
//        appName.frame = CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: headerView.bounds.height / 2)
//        appName.textColor = UIColor.white
//        appName.text = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
//        appName.textAlignment = .left
//        appName.font = UIFont(name: appName.font.fontName, size: 15)
//        headerView.addSubview(appName)
//
//        body = UILabel()
//        body.frame = CGRect(x: 10.0, y: appName.bounds.height, width: UIScreen.main.bounds.width, height: appName.bounds.height)
//        body.textColor = UIColor.white
//        body.text = aps["alert"] as? String
//        body.numberOfLines = 0
//        body.textAlignment = .left
//        body.font = UIFont(name: body.font.fontName, size: 12)
//        headerView.addSubview(body)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//            self.headerView.removeFromSuperview()
//        }
//    }

//    @available(iOS 10.0, *)
//    func addAttachment()
//    {
//        let Imgurl : URL = URL(string: "https://athemes.com/wp-content/uploads/Original-JPG-Image.jpg")!
//        let content = UNMutableNotificationContent()
//        do {
//            let attachment = try UNNotificationAttachment(identifier: "logo", url: Imgurl, options: nil)
//            content.attachments = [attachment]
//        } catch {
//            print("The attachment was not loaded.")
//        }
//    }
    
    func setCategories(){
        let cancle = UNNotificationAction(identifier: "cancle", title: "Cancle", options: [])
        let NotificationCategory = UNNotificationCategory(identifier: "cancle", actions: [cancle], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([NotificationCategory])
    }
    
}


@available(iOS 10.0, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler : @escaping(UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}
