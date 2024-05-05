//
//  NavigationController_.swift
//  DeliciousMeal
//
//  Created by Михаил Тихомиров on 25.04.2024.
//

import Foundation
import UIKit

extension UINavigationController {
    func setTitleColor() {
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Hoefler Text Black", size: 20)!
                ]
        
        let largeTitleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Hoefler Text Black", size: 40)!
            
        ]
            
        
        navigationBar.titleTextAttributes = titleAttributes
        navigationBar.largeTitleTextAttributes = largeTitleTextAttributes
    }
}
