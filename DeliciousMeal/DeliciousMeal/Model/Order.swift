//
//  Order.swift
//  DeliciousMeal
//
//  Created by Михаил Тихомиров on 28.04.2024.
//

import Foundation

class Order: Codable {
    
    enum Status:String {
        case delivering = "delivering"
        case cancelled = "cancelled"
    }
    
    enum CodingKeys: CodingKey {
        case orderName, stepperValueMain, countExtraOption1, countExtraOption2, typeExtraOption2, imageLink
    }
    
    var orderName: String
    
    var switch1: Bool = false
    var switch2: Bool = false
    var stepperValueMain: Int
    var stepperValue1: Int
    var stepperValue2: Int
    var pickerValue: String
    var imageLink: String
    
    var status: Status = .cancelled
    
    
    
    
    // for bread
    var countExtraOption1:Int {
        if switch1 {
            return stepperValue1
        }
        return 0
    }
    
    // for wine
    var countExtraOption2:Int {
        if switch2 {
            return stepperValue2
        }
        return 0
    }
    
    var typeExtraOption2: String {
        if switch2 {
            return pickerValue
        }
        return "-"
    }
    
    init(orderName: String, switch1: Bool, switch2: Bool, stepperValueMain: Int, stepperValue1: Int, stepperValue2: Int, pickerValue: String, imageLink: String) {
        
        self.orderName = orderName
        self.switch1 = switch1
        self.switch2 = switch2
        self.stepperValueMain = stepperValueMain
        self.stepperValue1 = stepperValue1
        self.stepperValue2 = stepperValue2
        self.pickerValue = pickerValue
        self.imageLink = imageLink
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.orderName, forKey: .orderName)
        try container.encode(self.stepperValueMain, forKey: .stepperValueMain)
        try container.encode(self.countExtraOption1, forKey: .countExtraOption1)
        try container.encode(self.countExtraOption2, forKey: .countExtraOption2)
        try container.encode(self.typeExtraOption2, forKey: .typeExtraOption2)
        try container.encode(self.imageLink, forKey: .imageLink)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        orderName = try container.decode(String.self, forKey: .orderName)
        stepperValueMain = try container.decode(Int.self, forKey: .stepperValueMain)
        stepperValue1 = try container.decode(Int.self, forKey: .countExtraOption1)
        stepperValue2 = try container.decode(Int.self, forKey: .countExtraOption2)
        pickerValue = try container.decode(String.self, forKey: .typeExtraOption2)
        imageLink = try container.decode(String.self, forKey: .imageLink)
    }
    
    
    
    
    
}
