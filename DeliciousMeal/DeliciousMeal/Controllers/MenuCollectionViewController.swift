//
//  MenuCollectionViewController.swift
//  DeliciousMeal
//
//  Created by Михаил Тихомиров on 19.04.2024.
//

import UIKit
import Kingfisher


class MenuCollectionViewController: UICollectionViewController {
    
    var menu: [Menu]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setTitleColor()
        title = "Menu"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    deinit {
        print("MenuCollectionViewController - deinit")
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menu.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Dish", for: indexPath) as! MenuCustomedCell
        let item = menu[indexPath.item]
        cell.name.text = item.name
        guard let url = URL(string: item.imageLink) else { 
            return cell
        }
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage"), options: [.transition(.fade(2))]) { result in
            switch result {
            case .success(_): break
            case .failure(_):
                print("Failed!")
            }
            
        }
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "OrderVC") as? OrderViewController {
            
            let selectedItem = menu[indexPath.item]
            
            if let cell = collectionView.cellForItem(at: indexPath) as? MenuCustomedCell {
                vc.itemMenu = selectedItem
                vc.sendedImage = cell.imageView.image
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
