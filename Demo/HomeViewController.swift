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
import CoreLocation
import GooglePlaces
import GooglePlacePicker


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var tblview: UITableView!
    
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    var dict : [String : AnyObject]!
    
    var msgArray : NSArray = NSArray()
    var photoArray : NSDictionary = NSDictionary()
    
    @IBOutlet weak var nearmebtn: UIButton!
    
    var RPConn : NSURLConnection = NSURLConnection()
    var RPData : NSMutableData = NSMutableData()
    
    var lat : Double = Double()
    var lng : Double = Double()
    
    var refresh : UIRefreshControl = UIRefreshControl()
    
    var height : Int = Int()
    var width : Int = Int()
    var reference : String = String()
    var name : String = String()
    var img : UIImage = UIImage()
    var API_KEY : String = "AIzaSyDkWnLbjYJfbRs5tU5Uen2FzEXe0g8W4Ag"
    
   var locationManager : CLLocationManager = CLLocationManager()
    
    let cellSpacingHeight: CGFloat = 5
    override func viewDidLoad() {
        super.viewDidLoad()
//        HomeImg()
        tblview.dataSource = self
        tblview.delegate = self
        tblview.addSubview(refresh)
        tblview.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        refresh.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        HomeImg()
    }
    @objc private func refreshWeatherData(_ sender: Any) {
        HomeImg()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        lat = locValue.latitude
        lng = locValue.longitude
        
    }
    
    @IBAction func SideMenubtn(_ sender: Any) {
        menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    
    //MARK:- Table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
        
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
        refresh.endRefreshing()
        activityIndecator.stopAnimating()
        activityIndecator.isHidden = true
        
        let di : NSDictionary = self.msgArray[indexPath.row] as! NSDictionary
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell",for: indexPath) as! HomeTableViewCell
        
        myCell.navigationmapbtn.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        
        myCell.titlelbl.text = di["name"] as? String
        return myCell
    }
   
    @objc func buttonTapped(sender : UIButton) {
        let alert = UIAlertController(title: "Add to Favorite", message: "Do you want to add this resturant as favorite ?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancle", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let di : NSDictionary = self.msgArray[indexPath.row] as! NSDictionary
        UserDefaults.standard.set(di["name"] as? String, forKey: "hotelName")
        UserDefaults.standard.set(di["vicinity"] as? String, forKey: "address")
        UserDefaults.standard.set(di["rating"] as! CGFloat, forKey: "rating")
        let lat : Double = ((di["geometry"] as! NSDictionary)["location"] as! NSDictionary)["lat"] as! Double
        let lng : Double = ((di["geometry"] as! NSDictionary)["location"] as! NSDictionary)["lng"] as! Double
        let data = (di["opening_hours"] as! NSDictionary)["open_now"] as! Bool
        var open : String = String()
        if(data)
        {
            open = "Open"
        }
        else
        {
            open = "Close"
        }
        UserDefaults.standard.set(di["place_id"] as! String, forKey: "placeid")
        UserDefaults.standard.set(open as String, forKey: "status")
        UserDefaults.standard.set(lat as Double, forKey: "lat")
        UserDefaults.standard.set(lng as Double, forKey: "lng")
        
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nearme(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func HomeImg()
    {
        self.tblview.separatorColor = UIColor.clear
        activityIndecator.isHidden = false
        activityIndecator.startAnimating()
        APIManager.sharedInstance.serviceGet("http://192.168.200.53:8552/nearme", headerParam: [:], successBlock:
            {(response) in
                self.dict = response as! [String : AnyObject]
                self.msgArray = self.dict["results"] as! NSArray
                
//                self.height = ((((self.dict["results"] as! NSArray)[0] as! NSDictionary)["photos"] as! NSArray)[0] as! NSDictionary)["height"] as! Int
                self.name = ((self.dict["results"] as! NSArray)[0] as! NSDictionary)["name"] as! String
                self.tblview.reloadData()
                self.tblview.separatorColor = UIColor.groupTableViewBackground
        }, failureBlock: {(error) in
                print(error)
        })
    }
}
