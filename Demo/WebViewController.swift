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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func back(_ sender: Any) {
        let param : [String : Any] = [
            "email" : "arjun@gmail.com"
        ]
        //POST
//        Alamofire.request("http://localhost:3000/register",method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { response in
//            print(response)
//        }
        Alamofire.request("http://localhost:3000/login",method: .post, parameters: [:], encoding: JSONEncoding.default).responseJSON { response in
            print(response)
        }
        
//        _ = self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
