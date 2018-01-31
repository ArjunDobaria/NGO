//
//  TableViewController.swift
//  Demo
//
//  Created by lanet on 31/01/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblview: UITableView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var headerView: UIView!
    
    let section = ["pizza", "deep dish pizza", "calzone"]
    let items = [["Margarita", "BBQ Chicken", "Pepperoni"], ["sausage", "meat lovers", "veggie lovers"], ["sausage", "chicken pesto", "prawns", "mushrooms"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tblview.sectionHeaderHeight = 60
//        tblview.sectionFooterHeight = 60

        tblview.tableFooterView = footerView
        tblview.tableHeaderView = headerView
        
        tblview.register(UINib(nibName: "CellTableViewCell", bundle: nil), forCellReuseIdentifier: "CellTableViewCell") 
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "hello"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "by"
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "CellTableViewCell") as? CellTableViewCell)!
        cell.textlabel1.text = "Data1"
        cell.textlabel2.text = "Data2"
        cell.textlabel3.text = "Data3"
        cell.textlabel4.text = "Data4"
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}
