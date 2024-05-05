//
//  ExtraTableViewController_.swift
//  DeliciousMeal
//
//  Created by Михаил Тихомиров on 25.04.2024.
//

import Foundation
import UIKit


extension ExtraTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return extraOptions[1].type.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // that`s our data we see in picker
        return extraOptions[1].type[row].rawValue
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "Hoefler Text", size: 20)
        label.text =  extraOptions[1].type[row].rawValue
        label.textAlignment = .center
        return label
    }
    
    
}
