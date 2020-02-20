//
//  CreateNotificationVC.swift
//  LocalNotificationsLab
//
//  Created by David Lin on 2/20/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit

class CreateNotificationVC: UIViewController {
    
    @IBOutlet weak var timePickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePickerView.dataSource = self
        timePickerView.delegate = self
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
            return 61
        default:
            return 61
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
    
    
    
}


extension CreateNotificationVC: UIPickerViewDelegate {
    
}
