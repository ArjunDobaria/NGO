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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func back(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
