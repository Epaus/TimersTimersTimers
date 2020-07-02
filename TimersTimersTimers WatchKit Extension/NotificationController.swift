//
//  NotificationController.swift
//  Timers WatchKit Extension
//
//  Created by Estelle Paus on 11/12/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import WatchKit
import SwiftUI
import UserNotifications

class NotificationController: WKUserNotificationHostingController<NotificationView> {
     @ObservedObject var model : ATimer
   
    var title: String?
    var message: String?
    
    init(model: ATimer) {
        self.model = model
        
    }
    
     override var body: NotificationView {
        NotificationView(title: model.title, message: "Timer Done")
       }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    

    override func didReceive(_ notification: UNNotification) {
        let notificationData =
            notification.request.content.userInfo as? [String: Any]
        
        let aps = notificationData?["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: Any]
        
        title = alert?["title"] as? String
        message = alert?["body"] as? String
    }
    
   
}
