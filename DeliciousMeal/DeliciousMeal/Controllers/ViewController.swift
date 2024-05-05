//
//  ViewController.swift
//  DeliciousMeal
//
//  Created by Михаил Тихомиров on 18.04.2024.
//

import UIKit
import Kingfisher

class ViewController: UITableViewController {
    // we call this func and send data of order and successful message when we return from checkoutVC
    func dataFromCheckoutVC(order: Order, message: String) {
        
        order.status = .delivering
        self.listOrders.append(order)
       
        tableView.reloadData()
        self.alertComfirmedOrder(message: message)
    }
    
    
    let menu: [Menu] = Bundle.main.decode(fileName: "Menu.json")
    var listOrders = [Order]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setTitleColor()
        
        let backgroundImage = UIImage(named: "background0")
        let backgroundImageView = UIImageView(image: backgroundImage)
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.bounds
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        tableView.backgroundView = backgroundImageView
         
        title = "Orders"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIButton(type: .system)
               addButton.setTitle("+", for: .normal)
               addButton.addTarget(self, action: #selector(addOrder), for: .touchUpInside)
               
               // Set custom font
               addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 35)
               addButton.setTitleColor(UIColor.white, for: .normal)
               
               // Create a UIBarButtonItem with the custom button as a custom view
               let addBarButton = UIBarButtonItem(customView: addButton)
               
               // Assign the UIBarButtonItem to the right bar button item
               navigationItem.rightBarButtonItem = addBarButton
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOrders.count
    }
    
    // we must set up this otherwise you get big image!
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)
        
        let order = listOrders[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.textProperties.font = UIFont(name: "Hoefler Text Black", size: 16)!
        content.textProperties.color = UIColor.white
        
        content.secondaryTextProperties.font = UIFont(name: "Hoefler Text", size: 12)!
        content.secondaryTextProperties.color = order.status == .delivering ? UIColor.green : UIColor.red
        
        content.text = "\(order.orderName) - \(order.stepperValueMain)"
        content.secondaryText = "Status: \(order.status.rawValue)"
        
        let url = URL(string: order.imageLink)!
        
        let imageView = UIImageView()
        
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage"), options: []) { result in
            switch result {
            case .success(_): break
            case .failure(_):
                print("Failed!")
            }
        }
        
        // set to content our image
        content.image = imageView.image
        // to make sure that our content wokrs we must send it to contentConfiguration
        cell.contentConfiguration = content

        return cell
    }
    
    // that`s for swipe action on table cell
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let order = listOrders[indexPath.row]
        
        let action = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, _ in
            order.status = .cancelled
            self?.tableView.reloadData()
        }
        
        action.image = UIImage(systemName: "xmark.square")
        action.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        
        return configuration
    }
    
    // func to process our message that we get from checkoutVC to show an alert
    func alertComfirmedOrder(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            let ac = UIAlertController(title: "Accepted", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }

    
    @objc func addOrder() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MenuVC") as? MenuCollectionViewController {
            vc.menu = menu
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

