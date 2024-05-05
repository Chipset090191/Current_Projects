//
//  ManageData.swift
//  DeliciousMeal
//
//  Created by Михаил Тихомиров on 30.04.2024.
//

import Foundation

class ManageData {
    
    static func saveAdressToUserDefaults(key: String, data: Address) {
        
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: key)
        } else {
            print("Couldn`t have done that!")
        }
        
    }
    
    
    static func loadAdressFromUserDefaults(key: String) -> Address? {
        if let data = UserDefaults.standard.data(forKey: key) {
            if let decoded = try? JSONDecoder().decode(Address.self, from: data) {
                return decoded
            } else {
                print ("Couldn`t have decoded data!")
            }
        }
        return nil
        
    }
    
}
