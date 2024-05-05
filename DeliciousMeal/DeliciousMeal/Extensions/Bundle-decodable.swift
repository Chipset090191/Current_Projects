//
//  Bundle-decodable.swift
//  DeliciousMeal
//
//  Created by Михаил Тихомиров on 19.04.2024.
//

import Foundation

extension Bundle {
    
    func decode(fileName: String) -> [Menu] {
        guard let url = self.url(forResource: fileName, withExtension: nil) else {
            fatalError("Failed to locate \(fileName) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load data from \(url)")
        }
        
        guard let decoded = try? JSONDecoder().decode([Menu].self, from: data) else {
            fatalError("Could not decoded our data to Struct!")
        }
        
        print("Menu is prepared!")
        return decoded
        
    }
    
}
