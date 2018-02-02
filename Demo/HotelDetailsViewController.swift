//
//  HotelDetailsViewController.swift
//  Demo
//
//  Created by lanet on 18/01/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import HCSStarRatingView

class HotelDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var urlbtn: UIButton!
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var centerview: UIView!
    @IBOutlet weak var openclosebtn: UIButton!
    @IBOutlet weak var closebtn: UIButton!
    @IBOutlet weak var favoritebtn: UIButton!
    
    @IBOutlet weak var hoteltimelbl: UILabel!
    @IBOutlet weak var headerRestaurantName: UILabel!
    @IBOutlet weak var nameOfRestaurant: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var away: UILabel!
    
    @IBOutlet weak var mapview: MKMapView!
    
    @IBOutlet weak var backgroundimg: UIImageView!
    
    @IBOutlet weak var aboutview: UIView!
    @IBOutlet weak var previewview: UIView!
    @IBOutlet weak var detailscontainerview: UIView!
    
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet weak var tblview2: UITableView!
    
    @IBOutlet weak var menubtn: UIButton!
    @IBOutlet weak var aboutbtn: UIButton!
    @IBOutlet weak var reviewbtn: UIButton!
    
    @IBOutlet weak var menuimg: UIImageView!
    @IBOutlet weak var aboutimg: UIImageView!
    @IBOutlet weak var reviewimg: UIImageView!
    
    @IBOutlet weak var maincoursebtn: UIButton!
    @IBOutlet weak var appetizeersbtn: UIButton!
    @IBOutlet weak var dessertbtn: UIButton!
    @IBOutlet weak var soupbtn: UIButton!
    
    @IBOutlet weak var ratinglbl: UILabel!
    @IBOutlet weak var ratingview: HCSStarRatingView!
    
    var locationManager : CLLocationManager    = CLLocationManager()
    let newPin = MKPointAnnotation()
    
    var dict : [String : AnyObject]!
    var placedict : [String : AnyObject]!
    
    var msgArray : NSArray = NSArray()
    var resultsArray : NSArray = NSArray()
    var reviewArray : NSArray = NSArray()
    
    var lat : Double = Double()
    var lng : Double = Double()
    var placeid : String = String()
    var fonts : UIFont = UIFont(name: "Helvetica", size: 20.0)!
    
    var distanceInMeters : Double = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        HotelFoodDetails()
        //MARK:- Map
        mapview.delegate = self
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        ratingview.value = UserDefaults.standard.object(forKey: "rating") as! CGFloat
        ratinglbl.text = String(describing: UserDefaults.standard.object(forKey: "rating") as! CGFloat)
        nameOfRestaurant.text = UserDefaults.standard.object(forKey: "hotelName") as? String
        headerRestaurantName.text = UserDefaults.standard.object(forKey: "hotelName") as? String
        address.text = UserDefaults.standard.object(forKey: "address") as? String
        openclosebtn.setTitle(UserDefaults.standard.object(forKey: "status") as? String, for: UIControlState.normal)
        
        //MARK:- Ltitude Longitude wise location
        mapview.removeAnnotation(newPin)
        let coordinates = CLLocationCoordinate2D(latitude: UserDefaults.standard.object(forKey: "lat") as! Double, longitude: UserDefaults.standard.object(forKey: "lng") as! Double)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(coordinates, span)
        mapview.region = region
        newPin.coordinate = coordinates
        mapview.addAnnotation(newPin)
        
//        print(heightForView(label: self.hoteltimelbl, text: " let left = UISwipeGestureRecognizer(target: self, action: #selector(leftside))right.direction = UISwipeGestureRecognizerDirection.leftdetailscontainerview.addGestureRecognizer(left)"))term
        
        tblview.dataSource = self
        tblview.delegate = self
        
        tblview2.dataSource = self
        tblview2.delegate = self
        
        tblview.register(UINib(nibName: "MenuitemsTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuitemsTableViewCell")
        tblview2.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewTableViewCell")
        
        menubtn.setTitleColor(UIColor.orange, for: UIControlState.normal)
        maincoursebtn.setTitleColor(UIColor.orange, for: UIControlState.normal)
        
        ImgHide(img1: menuimg, img2: aboutimg, img3: reviewimg)
        ViewHide(view1: detailscontainerview, view2: previewview, view3: aboutview)
        
        maincoursebtn.isSelected = true
        
        let right = UISwipeGestureRecognizer(target: self, action: #selector(rightside))
        right.direction = UISwipeGestureRecognizerDirection.right
        detailscontainerview.addGestureRecognizer(right)

        let left = UISwipeGestureRecognizer(target: self, action: #selector(leftside))
        right.direction = UISwipeGestureRecognizerDirection.left
        detailscontainerview.addGestureRecognizer(left)

        openclosebtn.layer.cornerRadius = 8
        
        placeid = UserDefaults.standard.object(forKey: "placeid") as! String
        
        PlaceDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func heightForView(label : UILabel, text : String) -> CGFloat {
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = fonts
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        lat = locValue.latitude
        lng = locValue.longitude
        distence()
    }
    func distence()
    {
        let coordinate₀ = CLLocation(latitude: lat, longitude: lng)
        let coordinate₁ = CLLocation(latitude: UserDefaults.standard.object(forKey: "lat") as! Double, longitude: UserDefaults.standard.object(forKey: "lng") as! Double)
        
        distanceInMeters = round(coordinate₀.distance(from: coordinate₁) / 1000)
        print("dataaa : " ,distanceInMeters)
        away.text = String(distanceInMeters) + "km Away"
    }
    
    //MARK:- Button action
    @IBAction func menubtn(_ sender: Any) {
        ButtonSelect(btn1: menubtn, btn2: aboutbtn, btn3: reviewbtn)
        ViewHide(view1: detailscontainerview, view2: previewview, view3: aboutview)
        ImgHide(img1: menuimg, img2: aboutimg, img3: reviewimg)
        backgroundimg.backgroundColor = UIColor.groupTableViewBackground
        ButtonTitleColor(btn1: menubtn, btn2: reviewbtn, btn3: aboutbtn)
    }
    
    @IBAction func aboutbtn(_ sender: Any) {
        ButtonSelect(btn1: aboutbtn, btn2: menubtn, btn3: reviewbtn)
        ViewHide(view1: aboutview, view2: previewview, view3: detailscontainerview)
        backgroundimg.backgroundColor = UIColor.white
        ImgHide(img1: aboutimg, img2: menuimg, img3: reviewimg)
        ButtonTitleColor(btn1: aboutbtn, btn2: reviewbtn, btn3: menubtn)
    }
    
    @IBAction func reviewbtn(_ sender: Any) {
        ButtonSelect(btn1: reviewbtn, btn2: aboutbtn, btn3: menubtn)
        ImgHide(img1: reviewimg, img2: menuimg, img3: aboutimg)
        ViewHide(view1: previewview, view2: aboutview, view3: detailscontainerview)
        backgroundimg.backgroundColor = UIColor.white
        ButtonTitleColor(btn1: reviewbtn, btn2: aboutbtn, btn3: menubtn)
    }
    
    @IBAction func maincoursebtn(_ sender: Any) {
        FourButtonSelect(btn1: maincoursebtn, btn2: appetizeersbtn, btn3: dessertbtn, btn4: soupbtn)
        FourButtonTitleColor(btn1: maincoursebtn, btn2: appetizeersbtn, btn3: dessertbtn, btn4: soupbtn)
        self.tblview.reloadData()
    }
    
    @IBAction func appetizeersbtn(_ sender: Any) {
        FourButtonSelect(btn1: appetizeersbtn, btn2: maincoursebtn, btn3: dessertbtn, btn4: soupbtn)
        FourButtonTitleColor(btn1: appetizeersbtn, btn2: maincoursebtn, btn3: dessertbtn, btn4: soupbtn)
        self.tblview.reloadData()
    }
    
    @IBAction func dessertbtn(_ sender: Any) {
        FourButtonSelect(btn1: dessertbtn, btn2: maincoursebtn, btn3: appetizeersbtn, btn4: soupbtn)
        FourButtonTitleColor(btn1: dessertbtn, btn2: maincoursebtn, btn3: appetizeersbtn, btn4: soupbtn)
        self.tblview.reloadData()
    }
    
    @IBAction func soupbtn(_ sender: Any) {
        FourButtonSelect(btn1: soupbtn, btn2: maincoursebtn, btn3: appetizeersbtn, btn4: dessertbtn)
        FourButtonTitleColor(btn1: soupbtn, btn2: maincoursebtn, btn3: appetizeersbtn, btn4: dessertbtn)
        self.tblview.reloadData()
    }
    
    @IBAction func closeviewbtn(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func webviewshowbtn(_ sender: Any) {
        let url : String = (urlbtn.titleLabel?.text)!
        UserDefaults.standard.set(url, forKey: "url")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func favoritrbtn(_ sender: Any) {
        //Favorite Hotel
    }
    //MARK:- Table view delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.tblview2)
        {
            return reviewArray.count
        }
        else{
            return msgArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == self.tblview2)
        {
            if(UIDevice.current.userInterfaceIdiom == .pad)
            {
                return 120
            }
            return 120
        }
        else{
            if(UIDevice.current.userInterfaceIdiom == .pad)
            {
                return 200
            }
            return 100
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        activityIndecator.stopAnimating()
        activityIndecator.isHidden = true
        if(tableView == self.tblview2)
        {
            let review : NSDictionary = self.reviewArray[indexPath.row] as! NSDictionary
            let cell = (tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell") as? ReviewTableViewCell)!
//            let datendtime = NSDate(timeIntervalSince1970: TimeInterval(review["time"] as! Int))
            _ = Date(timeIntervalSince1970: TimeInterval(review["time"] as! Int)) //Date from timeStamp
            
            cell.timelbl.text = review["relative_time_description"] as? String
            if(review["text"] as? String == "")
            {
                cell.reviewlbl.text = "No text available"
            }
            else{
                    cell.reviewlbl.text = review["text"] as? String
            }
            
            cell.usernamelbl.text = review["author_name"] as? String
            cell.rating.value = review["rating"] as! CGFloat
            
            return cell
        }
        else
        {
            let data : NSDictionary = self.msgArray[indexPath.row] as! NSDictionary
            let cell = (tableView.dequeueReusableCell(withIdentifier: "MenuitemsTableViewCell") as? MenuitemsTableViewCell)!
            
            if(maincoursebtn.isSelected)
            {
                cell.itemimg.image = UIImage.init(named: data["foodMainCourseImg"] as! String)
                cell.itemname.text = data["foodMainCourseName"] as? String
                cell.itemmoney.text = data["foodMainCoursePrice"] as? String
            }
            else if(appetizeersbtn.isSelected)
            {
                cell.itemimg.image = UIImage.init(named: data["foodAppetizersImg"] as! String)
                cell.itemname.text = data["foodAppetizersName"] as? String
                cell.itemmoney.text = data["foodAppetizersPrice"] as? String
            }
            else if(dessertbtn.isSelected)
            {
                cell.itemimg.image = UIImage.init(named: data["foodDessertImg"] as! String)
                cell.itemname.text = data["foodDessertName"] as? String
                cell.itemmoney.text = data["foodDessertPrice"] as? String
            }
            else if(soupbtn.isSelected)
            {
                cell.itemimg.image = UIImage.init(named: data["foodSoupImg"] as! String)
                cell.itemname.text = data["foodSoupName"] as? String
                cell.itemmoney.text = data["foodSoupPrice"] as? String
            }
            
            return cell
        }
       
        // set the text from the data model
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }

    @objc func rightside()
    {
        switch true {
        case maincoursebtn.isSelected:
            left(btn1: maincoursebtn, btn2: soupbtn)
        case appetizeersbtn.isSelected:
            left(btn1: appetizeersbtn, btn2: maincoursebtn)
        case dessertbtn.isSelected:
            left(btn1: dessertbtn, btn2: appetizeersbtn)
        case soupbtn.isSelected:
            left(btn1: soupbtn, btn2: dessertbtn)
        default:
            print("Default called")
        }
    }
    @objc func leftside()
    {
        switch true {
        case maincoursebtn.isSelected:
            left(btn1: maincoursebtn, btn2: appetizeersbtn)
        case appetizeersbtn.isSelected:
            left(btn1: appetizeersbtn, btn2: dessertbtn)
        case dessertbtn.isSelected:
            left(btn1: dessertbtn, btn2: soupbtn)
        case soupbtn.isSelected:
            left(btn1: soupbtn, btn2: maincoursebtn)
        default:
           print("Default called")
        }
    }
    
    //MARK:- Custom Helpers
    func ButtonSelect(btn1 : UIButton, btn2 : UIButton, btn3 : UIButton)
    {
        btn1.isSelected = true
        btn2.isSelected = false
        btn3.isSelected = false
    }
    
    func FourButtonSelect(btn1 : UIButton, btn2 : UIButton, btn3 : UIButton, btn4 : UIButton)
    {
        btn1.isSelected = true
        btn2.isSelected = false
        btn3.isSelected = false
        btn4.isSelected = false
    }
    
    func ViewHide(view1 : UIView, view2 : UIView, view3 : UIView)
    {
        view1.isHidden = false
        view2.isHidden = true
        view3.isHidden = true
    }
    func ImgHide(img1 : UIImageView, img2 : UIImageView, img3 : UIImageView)
    {
        img1.isHidden = false
        img2.isHidden = true
        img3.isHidden = true
    }
    
    func ButtonTitleColor(btn1 : UIButton, btn2 : UIButton, btn3 : UIButton)
    {
        btn1.setTitleColor(UIColor.orange, for: UIControlState.normal)
        btn2.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btn3.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
    }
    func FourButtonTitleColor(btn1 : UIButton, btn2 : UIButton, btn3 : UIButton, btn4 : UIButton)
    {
        btn1.setTitleColor(UIColor.orange, for: UIControlState.normal)
        btn2.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btn3.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btn4.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
    }
    
    func left(btn1 : UIButton, btn2 : UIButton)
    {
        btn1.isSelected = false
        btn1.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btn2.isSelected = true
        btn2.setTitleColor(UIColor.orange, for: UIControlState.normal)
    }
    func right(btn1 : UIButton, btn2 : UIButton)
    {
        btn1.isSelected = false
        btn1.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btn2.isSelected = true
        btn2.setTitleColor(UIColor.orange, for: UIControlState.normal)
    }
//    func map()
//    {
//        mapview.showsUserLocation = true
//
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.delegate = self
//
//        //Check for Location Services
//        if (CLLocationManager.locationServicesEnabled()) {
//            locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestAlwaysAuthorization()
//            locationManager.requestWhenInUseAuthorization()
//        }
//        locationManager.requestWhenInUseAuthorization()
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.startUpdatingLocation()
//        }
//
//        DispatchQueue.main.async {
//            self.locationManager.startUpdatingLocation()
//        }
        
//        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
//        centerMapOnLocation(location: initialLocation)

//    }
    
    //MARK:- Helper for Map
    //    func centerMapOnLocation(location: CLLocation) {
    //        mapview.removeAnnotation(newPin)
    //        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
    //                                                                  0.01, 0.01)
    //        mapview.setRegion(coordinateRegion, animated: true)
    //
    //    }
    
    //MARK:- Map Delegate to add pin on map
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        mapview.removeAnnotation(newPin)
//
//        let location = locations.last! as CLLocation
//
//        let center = CLLocationCoordinate2D(latitude: 21.282778, longitude: -157.829444)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//        //set region on the map
//        mapview.setRegion(region, animated: true)
//
//        newPin.coordinate = location.coordinate
//        mapview.addAnnotation(newPin)
//    }

    //MARK :- Service Call
    func HotelFoodDetails()
    {
        tblview.isHidden = true
        tblview2.isHidden = true
        activityIndecator.isHidden = false
        activityIndecator.startAnimating()
        APIManager.sharedInstance.serviceGet("http://192.168.200.53:8552/hoteldetails", headerParam: [:], successBlock:
            {(response) in
                print(response)
                self.dict = response as! [String : AnyObject]
                self.msgArray = self.dict["msg"] as! NSArray
                self.tblview.reloadData()
                self.tblview2.reloadData()
                self.tblview2.isHidden = false
                self.tblview.isHidden = false
        }, failureBlock:
            {(error) in
                print(error)
        })
    }
    
    func PlaceDetails()
    {
        activityIndecator.isHidden = false
        activityIndecator.startAnimating()
        APIManager.sharedInstance.serviceGet("https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyDkWnLbjYJfbRs5tU5Uen2FzEXe0g8W4Ag&placeid="+placeid , headerParam: [:], successBlock:
            {(response) in
//                print(response)
                self.placedict = response as! [String : AnyObject]
                self.reviewArray = (self.placedict["result"] as! NSDictionary)["reviews"] as! NSArray
                let times : String = (self.placedict["result"] as! NSDictionary)["url"] as! String               
                self.urlbtn.setTitle(times, for: UIControlState.normal)
                let data = (self.placedict["result"] as! NSDictionary)["types"] as! NSArray
                print(data)
                self.tblview.reloadData()
                self.tblview2.reloadData()
        }, failureBlock:
            {(error) in
                print(error)
        })
    }
}
