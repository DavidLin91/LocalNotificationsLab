//
//  ViewController.swift
//  LocalNotificationsLab
//
//  Created by David Lin on 2/20/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var notifications = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }


}

extension NotificationsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        let notification = notifications[indexPath.row]
        let identifier = notification.identifier
        
        return cell
    }
    
    
}
