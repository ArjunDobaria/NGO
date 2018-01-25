//
//  HomeViewController.swift
//  Demo
//
//  Created by lanet on 17/01/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit
import MFSideMenu
import Alamofire

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblview: UITableView!
    var dict : [String : AnyObject]!
    
    var dictonary:NSArray?
    
    var RPConn : NSURLConnection = NSURLConnection()
    var RPData : NSMutableData = NSMutableData()
    
    let cellSpacingHeight: CGFloat = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Alamofire.request("http://localhost:3000/home",method: .post, parameters: [:], encoding: JSONEncoding.default).responseJSON { response in
//            //            print(response.value! as! [String : AnyObject])
//            self.dict = response.value! as! [String : AnyObject]
//            self.dictonary = self.dict["msg"] as? NSArray
//            self.tblview.reloadData()
//        }

        HomeImg()
        
        tblview.dataSource = self
        tblview.delegate = self
        tblview.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func SideMenubtn(_ sender: Any) {
        menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    
    //MARK:- Table vire delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            return 400
        }
        return 200
    }
   
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let di : NSDictionary = self.dictonary![indexPath.row] as! NSDictionary
//        print(di["img"]!)
        
        // create a new cell if needed or reuse an old one
        let myCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        
        return myCell
        // set the text from the data model
    }
    
    
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func HomeImg()
    {
        let request:NSMutableURLRequest = NSMutableURLRequest(url: URL(string: "http://localhost:3000/home")!)
        request.httpShouldHandleCookies = false
        request.httpMethod = "POST"
        request.timeoutInterval = 60.0
        
        //        request.setValue(HeaderParameter.REQUEST_TOKEN as? String, forHTTPHeaderField: "Request-token")
        
        let sendData = NSMutableDictionary()
        
        let postString = AppDelegate().sharedDelegate().encodeDictionaryToString(sendData)
        
        let body = NSMutableData()
        body.append(postString.data(using: String.Encoding.utf8)!)
        
        request.httpBody = body as Data
        
        RPConn = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: true)!
        RPConn.start()
    }
    func connection(_ connection: NSURLConnection, didReceiveResponse response: URLResponse)
    {
            RPData = NSMutableData()
    }
    
    func connection(_ connection: NSURLConnection!, didReceiveData conData: Data!) {
        // Append the recieved chunk of data to our data object
       
            RPData.append(conData)
    }
    func connectionDidFinishLoading(_ connection: NSURLConnection!)
    {
            
            let jsonResult: NSDictionary = try!(JSONSerialization.jsonObject(with: RPData as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary)
            print(jsonResult)
    }

}
