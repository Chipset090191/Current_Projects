//
//  AddressViewController.swift
//  DeliciousMeal
//
//  Created by Михаил Тихомиров on 29.04.2024.
//

import UIKit



class CheckoutViewController: UIViewController {
    
        var nameOfDish: String = ""
        var switch1: Bool = false
        var switch2: Bool = false
        var stepperValueMain: Int = 0
        var stepperValue1: Int = 0
        var stepperValue2: Int = 0
        var pickerValue: String = ""
    
        var confirmationMessage = ""
        var acceptedOrder: Order?
        var imageLink: String = ""
        
        // Text fields
        let addressTextField = UITextField()
        let cityTextField = UITextField()
        let phoneTextField = UITextField()
        let labelOfTitle = UILabel()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            labelOfTitle.text = "Delivery address"
            
            configureTheTitle(title: labelOfTitle)
        
            view.addSubview(labelOfTitle)
        
            // Set up text fields
            configureTextField(addressTextField, placeholder: "Address")
            configureTextField(cityTextField, placeholder: "City")
            configureTextField(phoneTextField, placeholder: "Phone number")
            
            // Add text fields to the view
            view.addSubview(addressTextField)
            view.addSubview(cityTextField)
            view.addSubview(phoneTextField)
            
            // Positioning text fields
            positionTextFields()
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Accept", style: .done, target: self, action: #selector(createOrder))
            
            updateRightBarButtonItem()
        }
    
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            guard let address = ManageData.loadAdressFromUserDefaults(key: MyKeyForAddress.Key.rawValue) else { return }
            addressTextField.text = address.address
            cityTextField.text = address.city
            phoneTextField.text = address.phoneNumber
            updateRightBarButtonItem()
        }
    
    
    deinit {
        print("CheckoutViewController - deinit")
    }
    
    
        @objc func createOrder() {
            saveAddress()
            Task{
                await placeOrder()
                goToRootVC()
            }
        }
    
    
        @objc func textFieldDidChange(_ textField: UITextField) {
            updateRightBarButtonItem()
        }
    
    
        func saveAddress() {
            let data = Address(address: addressTextField.text!, city: cityTextField.text!, phoneNumber: phoneTextField.text!)
            ManageData.saveAdressToUserDefaults(key: MyKeyForAddress.Key.rawValue, data: data)
        }
    
    
        func configureTextField(_ textField: UITextField, placeholder: String) {
            // textFieldDidChange(_ :) - we call the func and send self to it
            textField.addTarget(self, action: #selector(textFieldDidChange(_ :)), for: .editingChanged)
            textField.placeholder = placeholder
            textField.borderStyle = .roundedRect
            textField.translatesAutoresizingMaskIntoConstraints = false
        }
    
    
        func updateRightBarButtonItem() {
            // if all three text fields have non-empty text, the code inside the if block will be executed!
            if let addressText = addressTextField.text,
               let cityText = cityTextField.text,
               let phoneText = phoneTextField.text,
               !addressText.isEmpty,
               !cityText.isEmpty,
               !phoneText.isEmpty {
                navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    
        func configureTheTitle(title: UILabel) {
            
            labelOfTitle.font = UIFont(name: "Hoefler Text", size: 20)
            labelOfTitle.textAlignment = .center
            labelOfTitle.translatesAutoresizingMaskIntoConstraints = false
        }
        
        func positionTextFields() {
            let margin: CGFloat = 20
            
            NSLayoutConstraint.activate([
                labelOfTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin),
                labelOfTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: margin),
                labelOfTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -margin),
                
                addressTextField.topAnchor.constraint(equalTo: labelOfTitle.bottomAnchor, constant: margin - 5),
                addressTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: margin),
                addressTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -margin),
                
                cityTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: margin - 5),
                cityTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: margin),
                cityTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -margin),
                
                
                phoneTextField.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: margin - 5),
                phoneTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: margin),
                phoneTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -margin)
            ])
        }
    
    
    // here we are posting our Order
    func placeOrder() async {
        let order = Order(orderName: self.nameOfDish, switch1: self.switch1, switch2: self.switch2, stepperValueMain: self.stepperValueMain, stepperValue1: self.stepperValue1, stepperValue2: self.stepperValue2, pickerValue: self.pickerValue, imageLink: self.imageLink)
        
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode my new order!")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/DeliciousFood")! // I hope the site will always be there!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // we then set our network request
        do {
            
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            // handle the result
            acceptedOrder = try JSONDecoder().decode(Order.self, from: data)
            
            
        } catch {
            print ("Checkout failed.")
        }
    }
    
    
    func goToRootVC() {
        guard let acceptedOrder = acceptedOrder else {
            print("Problem with order!")
            return
        }
        confirmationMessage = "Your order for \(acceptedOrder.orderName) - \(acceptedOrder.stepperValueMain) is on its way!"
                
                
        if let rootVC = navigationController?.viewControllers.first as? ViewController {
            rootVC.dataFromCheckoutVC(order: acceptedOrder, message: confirmationMessage)
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
}




