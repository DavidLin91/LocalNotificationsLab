//
//  PendingNotification.swift
//  LocalNotificationsLab
//
//  Created by David Lin on 2/20/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import Foundation
import UserNotifications

class PendingNotification {
    
    // returns us an array of request (whether it is 0 or 1,2,3,4)
    public func getpendingNotifications(completion: @escaping ([UNNotificationRequest]) -> ()) {
        //getPendingNotificaitons has been scheduled and not sent out yet
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print("there are \(requests.count) pending requests.")
            completion(requests)
        }
    }
    
}

