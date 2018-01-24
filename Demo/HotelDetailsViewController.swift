//
//  HotelDetailsViewController.swift
//  Demo
//
//  Created by lanet on 18/01/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit


class HotelDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var centerview: UIView!
    @IBOutlet weak var openclosebtn: UIButton!
    @IBOutlet weak var closebtn: UIButton!
    @IBOutlet weak var favoritebtn: UIButton!
    
//    @IBOutlet weak var mapview: MKMapView!
    
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
    
//    var locationManager : CLLocationManager    = CLLocationManager()
//    let newPin = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //MARK:- Map
//        mapview.delegate = self
        
      
        
        //MARK:- Ltitude Longitude wise location
        
//        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
//        centerMapOnLocation(location: initialLocation)
    
        tblview.dataSource = self
        tblview.delegate = self
        
        tblview2.dataSource = self
        tblview2.delegate = self
        
        tblview.register(UINib(nibName: "MenuitemsTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuitemsTableViewCell")
//
        tblview2.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewTableViewCell")
        
        menubtn.setTitleColor(UIColor.orange, for: UIControlState.normal)
        maincoursebtn.setTitleColor(UIColor.orange, for: UIControlState.normal)
        
        ImgHide(img1: menuimg, img2: aboutimg, img3: reviewimg)
        ViewHide(view1: detailscontainerview, view2: previewview, view3: aboutview)
        
        maincoursebtn.isSelected = true
        
//        let right = UISwipeGestureRecognizer(target: self, action: #selector(rightside))
//        right.direction = UISwipeGestureRecognizerDirection.right
//        detailscontainerview.addGestureRecognizer(right)
//
//        let left = UISwipeGestureRecognizer(target: self, action: #selector(leftside))
//        right.direction = UISwipeGestureRecognizerDirection.left
//        detailscontainerview.addGestureRecognizer(left)

        openclosebtn.layer.cornerRadius = 8
        
        centerview.viewshadow(view: centerview)
        detailscontainerview.viewshadow(view: detailscontainerview)
        
        detailscontainerview.frame = CGRect.init(x: 16, y: 0, width: UIScreen.main.bounds.width-32, height: subview.frame.height+500)
        detailscontainerview.backgroundColor = UIColor.white
        
        self.subview.addSubview(detailscontainerview)//give color to the view
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        detailscontainerview.removeFromSuperview()
        aboutview.removeFromSuperview()
        previewview.removeFromSuperview()
        detailscontainerview.frame = CGRect.init(x: 16, y: 0, width: UIScreen.main.bounds.width-32, height: subview.frame.height)
        detailscontainerview.backgroundColor = UIColor.white     //give color to the view
        
        self.subview.addSubview(detailscontainerview)
    }
    
    //MARK:- Helper for Map
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
//                                                                  regionRadius, regionRadius)
//        mapview.setRegion(coordinateRegion, animated: true)
//    }
    
    //MARK:- Map Delegate to add pin on map
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        mapview.removeAnnotation(newPin)
//
//        let location = locations.last! as CLLocation
//
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//        //set region on the map
//        mapview.setRegion(region, animated: true)
//
//        newPin.coordinate = location.coordinate
//        mapview.addAnnotation(newPin)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TButton action
    @IBAction func menubtn(_ sender: Any) {
        ButtonSelect(btn1: menubtn, btn2: aboutbtn, btn3: reviewbtn)
        ViewHide(view1: detailscontainerview, view2: previewview, view3: aboutview)
        ImgHide(img1: menuimg, img2: aboutimg, img3: reviewimg)
        backgroundimg.backgroundColor = UIColor.groupTableViewBackground
        ButtonTitleColor(btn1: menubtn, btn2: reviewbtn, btn3: aboutbtn)
        detailscontainerview.frame = CGRect.init(x: 16, y: 0, width: UIScreen.main.bounds.width-32, height: subview.frame.height)
        detailscontainerview.backgroundColor = UIColor.white     //give color to the view
        
        self.subview.addSubview(detailscontainerview)
        aboutview.removeFromSuperview()
        previewview.removeFromSuperview()
    }
    
    @IBAction func aboutbtn(_ sender: Any) {
        ButtonSelect(btn1: aboutbtn, btn2: menubtn, btn3: reviewbtn)
        ViewHide(view1: aboutview, view2: previewview, view3: detailscontainerview)
        backgroundimg.backgroundColor = UIColor.white
        ImgHide(img1: aboutimg, img2: menuimg, img3: reviewimg)
        ButtonTitleColor(btn1: aboutbtn, btn2: reviewbtn, btn3: menubtn)
        detailscontainerview.removeFromSuperview()
       
        aboutview.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: subview.frame.height)
        aboutview.backgroundColor = UIColor.white
        self.subview.addSubview(aboutview)
//        map()
        previewview.removeFromSuperview()
    }
    
    @IBAction func reviewbtn(_ sender: Any) {
        ButtonSelect(btn1: reviewbtn, btn2: aboutbtn, btn3: menubtn)
        ImgHide(img1: reviewimg, img2: menuimg, img3: aboutimg)
        ViewHide(view1: previewview, view2: aboutview, view3: detailscontainerview)
        backgroundimg.backgroundColor = UIColor.white
        ButtonTitleColor(btn1: reviewbtn, btn2: aboutbtn, btn3: menubtn)
        detailscontainerview.removeFromSuperview()
        aboutview.removeFromSuperview()
        previewview.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: subview.frame.height)
        previewview.backgroundColor = UIColor.white
        self.subview.addSubview(previewview)
    }
    
    @IBAction func maincoursebtn(_ sender: Any) {
        FourButtonSelect(btn1: maincoursebtn, btn2: appetizeersbtn, btn3: dessertbtn, btn4: soupbtn)
        FourButtonTitleColor(btn1: maincoursebtn, btn2: appetizeersbtn, btn3: dessertbtn, btn4: soupbtn)
    }
    
    @IBAction func appetizeersbtn(_ sender: Any) {
        FourButtonSelect(btn1: appetizeersbtn, btn2: maincoursebtn, btn3: dessertbtn, btn4: soupbtn)
        FourButtonTitleColor(btn1: appetizeersbtn, btn2: maincoursebtn, btn3: dessertbtn, btn4: soupbtn)
    }
    
    @IBAction func dessertbtn(_ sender: Any) {
        FourButtonSelect(btn1: dessertbtn, btn2: maincoursebtn, btn3: appetizeersbtn, btn4: soupbtn)
        FourButtonTitleColor(btn1: dessertbtn, btn2: maincoursebtn, btn3: appetizeersbtn, btn4: soupbtn)
    }
    
    @IBAction func soupbtn(_ sender: Any) {
        FourButtonSelect(btn1: soupbtn, btn2: maincoursebtn, btn3: appetizeersbtn, btn4: dessertbtn)
        FourButtonTitleColor(btn1: soupbtn, btn2: maincoursebtn, btn3: appetizeersbtn, btn4: dessertbtn)
    }
    
    @IBAction func closeviewbtn(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favoritrbtn(_ sender: Any) {
        //Favorite Hotel
    }
    //MARK:- Table view delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
        var cell : UITableViewCell = UITableViewCell()
        if(tableView == self.tblview2)
        {
            cell = (tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell") as? ReviewTableViewCell)!
            return cell
        }
        cell = (tableView.dequeueReusableCell(withIdentifier: "MenuitemsTableViewCell") as? MenuitemsTableViewCell)!
        
        return cell
        // set the text from the data model
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }

//    @objc func rightside()
//    {
//        switch true {
//        case maincoursebtn.isSelected:
//            left(btn1: maincoursebtn, btn2: soupbtn)
//        case appetizeersbtn.isSelected:
//            left(btn1: appetizeersbtn, btn2: maincoursebtn)
//        case dessertbtn.isSelected:
//            left(btn1: dessertbtn, btn2: appetizeersbtn)
//        case soupbtn.isSelected:
//            left(btn1: soupbtn, btn2: dessertbtn)
//        default:
//            print("Default called")
//        }
//    }
//    @objc func leftside()
//    {
//        switch true {
//        case maincoursebtn.isSelected:
//            left(btn1: maincoursebtn, btn2: appetizeersbtn)
//        case appetizeersbtn.isSelected:
//            left(btn1: appetizeersbtn, btn2: dessertbtn)
//        case dessertbtn.isSelected:
//            left(btn1: dessertbtn, btn2: soupbtn)
//        case soupbtn.isSelected:
//            left(btn1: soupbtn, btn2: maincoursebtn)
//        default:
//           print("Default called")
//        }
//    }
    
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
    
//    func left(btn1 : UIButton, btn2 : UIButton)
//    {
//        btn1.isSelected = false
//        btn1.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
//        btn2.isSelected = true
//        btn2.setTitleColor(UIColor.orange, for: UIControlState.normal)
//    }
//    func right(btn1 : UIButton, btn2 : UIButton)
//    {
//        btn1.isSelected = false
//        btn1.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
//        btn2.isSelected = true
//        btn2.setTitleColor(UIColor.orange, for: UIControlState.normal)
//    }
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
//    }
}
