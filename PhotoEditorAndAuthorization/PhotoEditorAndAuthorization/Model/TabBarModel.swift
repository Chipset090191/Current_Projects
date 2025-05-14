//
//  TabBarModel.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/8/25.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case drawing = "hand.draw"
    case texts = "textformat.characters.dottedunderline"
    case filters = "camera.filters"
    
    
    var title: String {
        switch self {
        case .drawing:
            return "Drawing"
        case .texts:
            return "Texts"
        case .filters:
            return "Filters"
        }
    }
}

struct AnimatedTab: Identifiable {
    var id = UUID()
    var tab: Tab
    var isAnimating: Bool?
}


