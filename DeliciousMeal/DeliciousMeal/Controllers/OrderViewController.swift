//
//  OrderViewController.swift
//  DeliciousMeal
//
//  Created by Михаил Тихомиров on 19.04.2024.
//

import UIKit

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var itemMenu: Menu!
    var sendedImage: UIImage!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var extraLineTableView: UITableView!
    @IBOutlet var ingredintsTableView: UITableView!
    @IBOutlet var topTitle: UILabel!
    

    var switch1: Bool = false
    var switch2: Bool = false
    var stepperValueMain: Int = 1
    var stepperValue1: Int = 1
    var stepperValue2: Int = 1
    var pickerValue: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Extra tableView
        extraLineTableView.delegate = self
        extraLineTableView.dataSource = self
        
        // Ingredients tableView
        ingredintsTableView.delegate = self
        ingredintsTableView.dataSource = self
        
        topTitle.text = itemMenu.name
        
        imageView.image = sendedImage
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart.badge.plus"),
                                                            style: .plain, target: self,
                                                            action: #selector(alertForOrder))
    }
    
    
    deinit {
        print("OrderViewController - deinit")
    }
    
    
    @objc func alertForOrder() {
        let str = messageListOfOrder()
        let ac = UIAlertController(title: "Information about Your order", message: str, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .destructive))
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: toOrder))
        present(ac, animated: true)
        
    }
    
    
    func messageListOfOrder() -> String {
        let firstOption = itemMenu.extraOptions[0].name
        let secondOption = itemMenu.extraOptions[1].name
        
        if self.switch1 && self.switch2 {
            return "Your order is:\n \(itemMenu.name) - \(stepperValueMain).\n Extra options:\n \(firstOption) - \(stepperValue1),\n \(secondOption) - \(stepperValue2) bottles of (\(pickerValue))."
        } else if self.switch1 && !self.switch2 {
            return "Your order is:\n \(itemMenu.name) - \(stepperValueMain).\n Extra options:\n \(firstOption) - \(stepperValue1)."
        } else if !self.switch1 && self.switch2 {
            return "Your order is:\n \(itemMenu.name) - \(stepperValueMain).\n Extra options:\n \(secondOption) - \(stepperValue2) bottles of (\(pickerValue))."
        }
        return "Your order is:\n \(itemMenu.name) - \(stepperValueMain).\n Extra options: no options."
    }
    
    
    func toOrder(action: UIAlertAction) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "checkoutVC") as? CheckoutViewController {
            vc.nameOfDish = self.itemMenu.name
            vc.switch1 = self.switch1
            vc.switch2 = self.switch2
            vc.stepperValueMain = self.stepperValueMain
            vc.stepperValue1 = self.stepperValue1
            vc.stepperValue2 = self.stepperValue2
            vc.pickerValue = self.pickerValue
            vc.imageLink = self.itemMenu.imageLink
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case extraLineTableView:
            return 1
        
        default:
            return itemMenu.ingredients.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        switch tableView {
        case extraLineTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "extraCell", for: indexPath)
            cell.textLabel?.text = "Extra options"
            return cell
        
        // for ingredintsTableView
        default:
            let ingredients = itemMenu.ingredients
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath)
            cell.textLabel?.text = "\(ingredients[indexPath.row].name):"
            cell.detailTextLabel?.text = "－\(ingredients[indexPath.row].count)"
            return cell
        }
     
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == ingredintsTableView {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
            
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.frame.width - 20, height: 30))
                    label.text = "Ingredients"
                    label.font =  UIFont(name: "Hoefler Text Black", size: 20)
                    label.textAlignment = .center
                    headerView.addSubview(label)
            
            return headerView
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == ingredintsTableView {
            return 50
        }
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "extraTableVC") as? ExtraTableViewController {
            
            vc.nameOfDish = itemMenu.name
            vc.extraOptions = itemMenu.extraOptions
            
            vc.switch1 = self.switch1
            vc.switch2 = self.switch2
            vc.stepperValueMain = self.stepperValueMain
            vc.stepperValue1 = self.stepperValue1
            vc.stepperValue2 = self.stepperValue2
            vc.pickerValue = self.pickerValue
            
            navigationController?.pushViewController(vc, animated: true)
            
            vc.onComplition = { [weak self] stepperValueMain, switch1, switch2, stepper1Value, stepper2Value, pickerValue  in
                guard let self = self else { return }
                
                self.stepperValueMain = stepperValueMain
                self.switch1 = switch1
                self.switch2 = switch2
                self.stepperValue1 = stepper1Value
                self.stepperValue2 = stepper2Value
                self.pickerValue = pickerValue
            }
        }
    }
    
}
