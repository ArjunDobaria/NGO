//
//  CustomeSideMenuViewController.swift
//  Demo
//
//  Created by lanet on 06/02/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit

class CustomeSideMenuViewController: UIViewController {

    @IBOutlet weak var sideConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var sideView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurView.layer.cornerRadius = 15
        
        sideView.layer.shadowColor = UIColor.black.cgColor
        sideView.layer.shadowOpacity = 0.8
        sideView.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        
        
    }
    
    @IBAction func back(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    @IBAction func panPerformed(_ sender: UIPanGestureRecognizer) {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            if sender.state == .began || sender.state == .changed {
                let translation = sender.translation(in: self.view).x
                if translation > 0 {
                    //swipe Right
                    if sideConstraint.constant < 100 {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.sideConstraint.constant += translation / 10
                            self.view.layoutIfNeeded()
                        })
                    }
                }
                else{
                    //swipe left
                    if sideConstraint.constant > -250 {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.sideConstraint.constant += translation / 10
                            self.view.layoutIfNeeded()
                        })
                    }
                }
            }
            else if sender.state == .ended {
                if sideConstraint.constant < -100 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.sideConstraint.constant = -250
                        self.view.layoutIfNeeded()
                    })
                }
                else{
                    UIView.animate(withDuration: 0.2, animations: {
                        self.sideConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
        else
        {
            if sender.state == .began || sender.state == .changed {
                let translation = sender.translation(in: self.view).x
                if translation > 0 {
                    //swipe Right
                    if sideConstraint.constant < 100 {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.sideConstraint.constant += translation / 10
                            self.view.layoutIfNeeded()
                        })
                    }
                }
                else{
                    //swipe left
                    if sideConstraint.constant > -175 {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.sideConstraint.constant += translation / 10
                            self.view.layoutIfNeeded()
                        })
                    }
                }
            }
            else if sender.state == .ended {
                if sideConstraint.constant < -100 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.sideConstraint.constant = -175
                        self.view.layoutIfNeeded()
                    })
                }
                else{
                    UIView.animate(withDuration: 0.2, animations: {
                        self.sideConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
