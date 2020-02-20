//
//  CreateNotificationVC.swift
//  LocalNotificationsLab
//
//  Created by David Lin on 2/20/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit

protocol CreateNotificatonControllerDelegate: AnyObject {
    func didCreateNotification(_ createNotificationController: CreateNotificationVC)
}


class CreateNotificationVC: UIViewController {
    
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var titleTextField: UITextField!
    
    weak var delegate: CreateNotificatonControllerDelegate?
    
    private var timeInterval: TimeInterval! = Date().timeIntervalSinceNow
    
    var seconds = 0
    var minutes = 0
    var hours = 0
    
    var totalTime = Double()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePickerView.dataSource = self
        timePickerView.delegate = self
    }
    
    
    private func createLocalNotification() {
        // step 1: create the content
        let content = UNMutableNotificationContent()
        content.title = titleTextField.text ?? "No Title"
        content.subtitle = "Learning Local Notifications"
        content.body = "Local Notificaitons is awesome when used appropriately"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "pikachu.mp3")) //only works in the background and the app is not on silent
        
        // create identifier
        let identifier = UUID().uuidString // unique string
        
        if let imageURL = Bundle.main.url(forResource: "pika", withExtension: "jpeg") {
            do {
                let attachment = try UNNotificationAttachment(identifier: identifier, url: imageURL, options: nil)
                content.attachments = [attachment]
            } catch {
                print("error with attachment \(error)")
            }
        } else {
            print("image resource could not be found")
        }
        
        // create a trigger
        // 3 possible triggers for local notificaitons: time interval, calendar, location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval , repeats: false)
        
        
        // create a request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // add request to the UNNotifications
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("error adding request: \(error)")
            } else {
                print("request was successfully added")
            }
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        createLocalNotification()
        delegate?.didCreateNotification(self)
        dismiss(animated: true)
    }
    
    
    
    
    
    
    
    
}


extension CreateNotificationVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 11
        case 1:
            return 60
        default:
            return 60
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) Hr"
        case 1:
            return "\(row) Min"
        default:
            return "\(row) Sec"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hours = row * 3600
            print("hours :\(hours)")
        case 1:
            minutes = row * 60
            print("minutes: \(minutes)")
        default:
            seconds = row * 1
            print("seconds: \(seconds)")
            
            totalTime = Double(hours + minutes + seconds)
            timeInterval = totalTime
        }
    }
}


extension CreateNotificationVC: UIPickerViewDelegate {
    
}
