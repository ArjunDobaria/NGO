//
//  NotificationViewController.swift
//  RichNotificationContent
//
//  Created by lanet on 05/02/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import CoreMotion

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    
    @IBOutlet weak var imgView: UIImageView!
    
    var manager = CMMotionManager()
    
    func accelometerUpdate() {
        if manager.isGyroAvailable {
            manager.gyroUpdateInterval = 0.1
            manager.startGyroUpdates()
        }
        
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.01
            manager.startDeviceMotionUpdates(to: .main) {
                [weak self] (data: CMDeviceMotion?, error: Error?) in
                if let gravity = data?.gravity {
                    let rotation = atan2(gravity.x, gravity.y) - Double.pi
                    self?.imgView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accelometerUpdate()
        
        let size = view.bounds.size
        preferredContentSize = CGSize(width: size.width, height: size.height / 2)
    }
    
    func didReceive(_ notification: UNNotification) {
       
            
            // Grab the attachment
            if let urlString = notification.request.content.userInfo["attachment-url"], let fileUrl = URL(string: urlString as! String) {

                let imageData = NSData(contentsOf: fileUrl)
                let image = UIImage(data: imageData! as Data)!

                imgView.image = image
                accelometerUpdate()
            }
        
    }

}
