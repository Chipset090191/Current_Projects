//
//  ExtraTableViewController.swift
//  DeliciousMeal
//
//  Created by Михаил Тихомиров on 20.04.2024.
//

import UIKit

class ExtraTableViewController: UITableViewController {
    
    var nameOfDish: String!
    
    var onComplition: ((Int, Bool, Bool, Int, Int, String)-> Void)?
    
    //MARK: -Outlets
    @IBOutlet var switchFirstOption: UISwitch!
    @IBOutlet var switchSecondOption: UISwitch!
    @IBOutlet var name1Label: UILabel!
    @IBOutlet var name2Label: UILabel!
    @IBOutlet var count1Label: UILabel!
    @IBOutlet var count2Label: UILabel!
    @IBOutlet var stepperFirstOption: UIStepper!
    @IBOutlet var stepperSecondOption: UIStepper!
    @IBOutlet var pickerSecondOption: UIPickerView!
    @IBOutlet var typeSecondOption: UILabel!
    
    @IBOutlet var nameLabelMain: UILabel!
    @IBOutlet var countLabelMain: UILabel!
    @IBOutlet var stepperMainOption: UIStepper!
    
    //MARK: -
    
    var extraOptions: [ExtraOption]!
    
    var switch1: Bool = false
    var switch2: Bool = false
    var stepperValueMain: Int = 1
    var stepperValue1: Int = 1
    var stepperValue2: Int = 1
    var pickerValue: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerSecondOption.delegate = self
        pickerSecondOption.dataSource = self
        checkOptions()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let selectedRow = pickerSecondOption.selectedRow(inComponent: 0)
        let pickerValue = extraOptions[1].type[selectedRow].rawValue
        
        let stepperMainValue = Int(stepperMainOption.value)
        let stepper1Value = Int(stepperFirstOption.value)
        let stepper2Value = Int(stepperSecondOption.value)
        
        let switch1 = switchFirstOption.isOn
        let switch2 = switchSecondOption.isOn
        
        
        if switchFirstOption.isOn && switchSecondOption.isOn {
            onComplition?(stepperMainValue,switch1,switch2,stepper1Value,stepper2Value,pickerValue)
            
        } else if switchFirstOption.isOn {
            onComplition?(stepperMainValue,switch1,switch2,stepper1Value,0,"-")
        } else if switchSecondOption.isOn {
            onComplition?(stepperMainValue,switch1,switch2,0,stepper2Value,pickerValue)
        } else {
            // both switches were disabled
            onComplition?(stepperMainValue,switch1,switch2,stepper1Value,stepper2Value,pickerValue)
        }
        
    }
    
    
    @IBAction func EnableFirstOption(_ sender: UISwitch) {
        stepperFirstOption.isEnabled = sender.isOn
        if !sender.isOn {
            count1Label.text = "(Count: 0)"
            stepperFirstOption.value = 1
        } else {
            count1Label.text = "(Count: 1)"
        }
    }
    
    
    @IBAction func EnableSecondOption(_ sender: UISwitch) {
        stepperSecondOption.isEnabled = sender.isOn
        pickerSecondOption.isHidden = !sender.isOn
        typeSecondOption.isHidden = !sender.isOn
        
        if !sender.isOn {
            count2Label.text = "(Count: 0)"
            stepperSecondOption.value = 1
        } else {
            count2Label.text = "(Count: 1)"
        }
    }
    
    
    @IBAction func setCountMainOption(_ sender: UIStepper) {
        let currentStepperValue = Int(sender.value)
        countLabelMain.text = "(Count: \(currentStepperValue))"
    }
    
    
    @IBAction func setCountFirstOption(_ sender: UIStepper) {
        let currentStepperValue = Int(sender.value)
        
        count1Label.text = "(Count: \(currentStepperValue))"
    }
    
    
    @IBAction func setCountSecondOption(_ sender: UIStepper) {
        let currentStepperValue = Int(sender.value)
        count2Label.text = "(Count: \(currentStepperValue))"
    }
    
    
    func checkOptions() {
        nameLabelMain.text = nameOfDish
        
        name1Label.text = extraOptions[0].name.rawValue

        name2Label.text = extraOptions[1].name.rawValue

        countLabelMain.text = "(Count: \(stepperValueMain))"
        
        
        if switch1 {
            switchFirstOption.isOn = switch1
            stepperFirstOption.isEnabled = true
            stepperFirstOption.value = Double(stepperValue1)
            count1Label.text = "(Count: \(stepperValue1))"
        } else {
            switchFirstOption.isOn = false
            stepperFirstOption.isEnabled = false
        }
        
        
        if switch2 {
            switchSecondOption.isOn = switch2
            stepperSecondOption.isEnabled = true
            typeSecondOption.isHidden = false
            pickerSecondOption.isHidden = false
            stepperSecondOption.value = Double(stepperValue2)
            count2Label.text = "(Count: \(stepperValue2))"
            
            if pickerValue != "" {
                if let index = extraOptions[1].type.firstIndex(of: TypeElement(rawValue: pickerValue) ?? .dryRed) {
                    pickerSecondOption.selectRow(index, inComponent: 0, animated: false)
                }
            }
        } else {
            switchSecondOption.isOn = false
            stepperSecondOption.isEnabled = false
            pickerSecondOption.isHidden = true
            typeSecondOption.isHidden = true
        }
    }
}
