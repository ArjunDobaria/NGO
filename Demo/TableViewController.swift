//
//  TableViewController.swift
//  Demo
//
//  Created by lanet on 31/01/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate {

    @IBOutlet weak var tblview: UITableView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var headerView: UIView!
    
    var collapsed : Bool = Bool()
    
    let section = ["Pizza", "Deep dish pizza", "Calzone","Pizza", "Deep dish pizza", "Calzone"]
    let items = [["Margarita", "BBQ Chicken", "Pepperoni"], ["sausage", "meat lovers", "veggie lovers"], ["sausage", "chicken pesto", "prawns", "mushrooms"],["Margarita", "BBQ Chicken", "Pepperoni"], ["sausage", "meat lovers", "veggie lovers"], ["sausage", "chicken pesto", "prawns", "mushrooms"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collapsed = false
//        tblview.tableFooterView = footerView
//        tblview.tableHeaderView = headerView
        
        tblview.estimatedRowHeight = 44.0
        tblview.rowHeight = UITableViewAutomaticDimension
        
        tblview.register(UINib(nibName: "CellTableViewCell", bundle: nil), forCellReuseIdentifier: "CellTableViewCell") 
        
        // Do any additional setup after loading the view.
    }

    @IBAction func back(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Table View Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.section.count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return self.section[section]
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return collapsed ? UITableViewAutomaticDimension : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v = UITableViewHeaderFooterView()
        v.textLabel?.text = self.section[section]
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(<#UIGestureRecognizer#>, row : section)))
        tapRecognizer.delegate = self
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        v.addGestureRecognizer(tapRecognizer)
        return v
    }
    
    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer,row : Int)
    {
        
        print(row)
        if(collapsed)
        {
            collapsed = false
        }else{
            collapsed = true
        }
        
        return tblview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTableViewCell", for: indexPath)
        let items = self.items[indexPath.section]
        let item = items[indexPath.row]
        cell.textLabel?.textColor = UIColor.lightGray
        cell.textLabel?.text = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Touch")
    }
}

