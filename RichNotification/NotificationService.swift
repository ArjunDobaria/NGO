//
//  NotificationService.swift
//  RichNotification
//
//  Created by lanet on 05/02/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UserNotifications
import UIKit

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        /*
         
         This type of Payload is acceptable for the extension
         
         {
            "aps": {
                "alert": {
                    "title": "Hello",
                    "body": "body.."
                },
                "mutable-content":1,
                "sound": "default",
                "badge": 1,
         
            },
            "attachment-url": "https://cms-assets.tutsplus.com/uploads/users/769/posts/26870/preview_image/ios-10@2x.jpg"
         }
         
         silent Push Notificatio PayLoad
         
         {
            "aps" = {
                "content-available" : 1,
                    "sound" : ""
            };
            // You can add custom key-value pair here...
         }
         
         */
        
            // Grab the attachment
            if let urlString = request.content.userInfo["attachment-url"], let fileUrl = URL(string: urlString as! String) {
                // Download the attachment
                URLSession.shared.downloadTask(with: fileUrl) { (location, response, error) in
                    if let location = location {
                        // Move temporary file to remove .tmp extension
                        let tmpDirectory = NSTemporaryDirectory()
                        let tmpFile = "file://".appending(tmpDirectory).appending(fileUrl.lastPathComponent)
                        let tmpUrl = URL(string: tmpFile)!
                        try! FileManager.default.moveItem(at: location, to: tmpUrl)
                        
                        // Add the attachment to the notification content
                        if let attachment = try? UNNotificationAttachment(identifier: "", url: tmpUrl) {
                            self.bestAttemptContent?.attachments = [attachment]
                        }
                    }
                    // Serve the notification content
                    self.contentHandler!(self.bestAttemptContent!)
                    }.resume()
            }
        
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}

