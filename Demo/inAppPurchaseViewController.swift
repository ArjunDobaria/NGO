//
//  inAppPurchaseViewController.swift
//  Demo
//
//  Created by lanet on 05/02/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit
import StoreKit

class inAppPurchaseViewController: UIViewController, SKProductsRequestDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    var productIDs : Array<String>! = []
    var productArray : Array<SKProduct?> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productIDs.append("com.lanet.NGO1")
        requestProductInfo()
    }

    func requestProductInfo()
    {
        if SKPaymentQueue.canMakePayments(){
            let productIdentifires = NSSet(array : productIDs)
            let productRequest = SKProductsRequest(productIdentifiers : productIdentifires as Set<NSObject> as! Set<String>)
            productRequest.delegate = self
            productRequest.start()
        }
        else{
            print("Can not perform inApp-purchase")
        }
    }
    
    //MARK:- Delegate of SKProductRequest
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products{
                productArray.append(product)
            }
            tblView.reloadData()
        }
        else{
            print("The Productsa are not available")
        }
        
        if response.invalidProductIdentifiers.count != 0 {
            print(response.invalidProductIdentifiers.description)
        }
    }
    
    //MARK:- Delegate of Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell()
        let product = productArray[indexPath.row]
        cell.textLabel?.text = product?.localizedTitle
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
