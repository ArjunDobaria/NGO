//
//  WebViewController.swift
//  Demo
//
//  Created by lanet on 24/01/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class WebViewController: UIViewController {
    
    var dict : [String : AnyObject]!
    
    var dictonary:NSArray?
    var jsonString : String = ""
    
    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if( UserDefaults.standard.object(forKey: "url") as! String != "")
        {
            let data : String = UserDefaults.standard.object(forKey: "url") as! String
            let url = URL (string: data)
            let requestObj = URLRequest(url: url!)
            webview.loadRequest(requestObj)
        }
        else
        {
            let lat : Double = UserDefaults.standard.object(forKey: "lat") as! Double
            let lng : Double = UserDefaults.standard.object(forKey: "lng") as! Double
            let data : String = "https://www.google.com/maps/search/restaurants+near+me/@"+String(format:"%f", lat)+","+String(format:"%f", lng)+",14z/data=!3m1!4b1"
            let url = URL (string: data)
            let requestObj = URLRequest(url: url!)
            webview.loadRequest(requestObj)
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        UserDefaults.standard.set("",forKey: "url")
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
