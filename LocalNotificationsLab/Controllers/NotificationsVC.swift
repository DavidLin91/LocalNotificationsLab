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
    
    private var notifications = [UNNotificationRequest]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // singleton
    private let center = UNUserNotificationCenter.current()
    
    // instantiated a class so it can be used throughout VC
    private let pendingNotificaitons = PendingNotification()
    
    private var refreshControl: UIRefreshControl!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForNotificationAuthorization()
        tableView.dataSource = self
        center.delegate = self
        configureRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadNotifications), for: .valueChanged)
        loadNotifications()
    }
    
    
    
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
            let createVC = navController.viewControllers.first as? CreateNotificationVC else {
                fatalError("could not downcast to CreateNotificationsVC")
        }
        createVC.delegate = self
    }
    
    
    
    @objc private func loadNotifications() {
        // calls on the instantiated object "pendingNotifications"
        pendingNotificaitons.getpendingNotifications { (requests) in
            self.notifications = requests
            
            // stop the refresh conrol from animating and remove from the UI
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    
    
    private func checkForNotificationAuthorization() {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                print("app is authorized for notificaitons")
            } else {
                self.requestNotificationPermission()
            }
        }
    }
    
    
    
    private func requestNotificationPermission() {
        center.requestAuthorization(options: [.alert,.sound]) { (granted, error) in
            if let error = error {
                print("error requestiong authorization: \(error)")
                return
            }
            if granted {
                print ("access was granted")
            } else {
                print("access denied")
            }
        }
    }
    
}

extension NotificationsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        let notification = notifications[indexPath.row]
        cell.textLabel?.text = notification.content.title
        return cell
    }
    
    // func listens for swipes from user
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // we will delete the pending notification
            removeNotification(atIndexPath: indexPath)
        }
    }
    
    private func removeNotification(atIndexPath indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        let identifier = notification.identifier
        // remove notifiication from UNNotificationCenter
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        // remove from array of notifications
        notifications.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        // remove from table view
        
    }
    
    
}


extension NotificationsVC : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}


// conforming to the protocol created in CreateNotificationVC
extension NotificationsVC: CreateNotificatonControllerDelegate {
    func didCreateNotification(_ createNotificationController: CreateNotificationVC) {
        loadNotifications()
    }
}
