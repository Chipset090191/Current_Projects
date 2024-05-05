//
//  Menu.swift
//  DeliciousMeal
//
//  Created by Михаил Тихомиров on 19.04.2024.
//

import Foundation

// MARK: - MenuElement
struct Menu: Codable {
    let name: String
    let imageLink: String
    let ingredients: [Ingredient]
    let extraOptions: [ExtraOption]
}

// MARK: - ExtraOption
struct ExtraOption: Codable {
    let name: Name
    let type: [TypeElement]
    
}

enum Name: String, Codable {
    case bread = "bread"
    case wine = "wine"
}

enum TypeElement: String, Codable {
    //for bread
    case black = "black"
    case white = "white"
    //for wine
    case dryRed = "Dry-Red"
    case whiteSemiSweet = "White semi-sweet"
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let name, count: String
}






