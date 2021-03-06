//
//  SideMenuViewController.swift
//  Demo
//
//  Created by lanet on 23/01/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit
import MFSideMenu
import GoogleSignIn
import FBSDKLoginKit

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblview: UITableView!
     var tableData:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            menuContainerViewController.menuWidth = 400
        }
        tableData = NSMutableArray(objects: "Side Menu", "In App", "tableView", "WebView", "Logout")
        self.tblview.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = tableData[indexPath.row] as? String
        return (cell)!
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)
    {
        tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.white
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor.black
        tableView.cellForRow(at: indexPath)?.textLabel?.font = UIFont(name:"System", size:22)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let rootNav:UINavigationController = self.menuContainerViewController.centerViewController as! UINavigationController
        
        switch indexPath.row
        {
        case 0:
            let vc: CustomeSideMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomeSideMenuViewController") as! CustomeSideMenuViewController
            rootNav.pushViewController(vc, animated: true)
            break
            
        case 1:
            let vc: inAppPurchaseViewController = self.storyboard?.instantiateViewController(withIdentifier: "inAppPurchaseViewController") as! inAppPurchaseViewController
            rootNav.pushViewController(vc, animated: true)
            break
            
        case 2:
            let vc: TableViewController = self.storyboard?.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
            rootNav.pushViewController(vc, animated: true)
            break
            
        case 3:
            let vc: WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            rootNav.pushViewController(vc, animated: true)
            break
            
        case 4:
                if(UserDefaults.standard.object(forKey: "login") as! String == "fb")
                {
                    UserDefaults.standard.set(false, forKey: "isUserLogin")
                    UserDefaults.standard.synchronize()
                    let loginManager = FBSDKLoginManager()
                    loginManager.logOut()
                    let vc: ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    rootNav.pushViewController(vc, animated: true)
                }
                else if(UserDefaults.standard.object(forKey: "login") as! String == "gp")
                {
                    UserDefaults.standard.set(false, forKey: "isUserLogin")
                    UserDefaults.standard.synchronize()
                    GIDSignIn.sharedInstance().signOut()
                    let vc: ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    rootNav.pushViewController(vc, animated: true)
                }
            break
            
        default:
            print("Default")
            break
        }
        menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }

}
