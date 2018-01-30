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
       
        tblview.dataSource = self
        tblview.delegate = self
        tblview.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
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
    
    //MARK:- Table vire delegate
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
        activityIndecator.stopAnimating()
        activityIndecator.isHidden = true
        
        let di : NSDictionary = self.msgArray[indexPath.row] as! NSDictionary
        
        self.loadFirstPhotoForPlace(placeID: di["place_id"] as! String)
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
//        myCell.bannerImg.image = img
        myCell.titlelbl.text = di["name"] as? String
//        myCell.subtitle1lbl.text = di["mainFood"] as? String
//        myCell.subtitle2lbl.text = di["favorite"] as? String
        return myCell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let di : NSDictionary = self.msgArray[indexPath.row] as! NSDictionary

//        UserDefaults.standard.set(di["away"] as? String, forKey: "away")
//        UserDefaults.standard.set(di["status"] as? String, forKey: "status")
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
        tblview.isHidden = true
        activityIndecator.isHidden = false
        activityIndecator.startAnimating()
        APIManager.sharedInstance.serviceGet("http://202.47.116.116:8552/nearme", headerParam: [:], successBlock:
            {(response) in
//                print(response)
                self.dict = response as! [String : AnyObject]
                self.msgArray = self.dict["results"] as! NSArray
                
                self.height = ((((self.dict["results"] as! NSArray)[0] as! NSDictionary)["photos"] as! NSArray)[0] as! NSDictionary)["height"] as! Int
                self.name = ((self.dict["results"] as! NSArray)[0] as! NSDictionary)["name"] as! String
//                self.loadFirstPhotoForPlace(placeID: ((self.dict["results"] as! NSArray)[0] as! NSDictionary)["place_id"] as! String)
//        let data = ((((self.dict["results"] as! NSArray)[0] as! NSDictionary)["geometry"] as! NSDictionary)["location"] as! NSDictionary)["lat"] as? Double
//        self.reference = ((((self.dict["results"] as! NSArray)[0] as! NSDictionary)["photos"] as! NSArray)[0] as! NSDictionary)["photo_reference"] as! String
        self.tblview.reloadData()
                self.tblview.isHidden = false
        }, failureBlock: {(error) in
                print(error)
        })
    }
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    print(placeID)
                    print(firstPhoto)
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                self.img = photo!;
//                let attributedText = photoMetadata.attributions;
            }
        })
    }
    
}
