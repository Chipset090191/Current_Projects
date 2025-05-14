//
//  Modifiers.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/8/25.
//

import SwiftUI


struct backgroundGray6: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(.systemGray6))
    }
    
}




struct ConditionalBackground: ViewModifier {
    var isTapped: Bool

    func body(content: Content) -> some View {
        content
            .background(isTapped ? Color(.white) : Color(.systemGray6))
    }
}




struct pickerTintColor: ViewModifier {
    func body (content: Content) -> some View {
        content
            .tint(Color.black).opacity(0.8)
    }
}


struct EditableTextModifier: ViewModifier {
    
    var fontSize: CGFloat
    var fontStyle: Font.Weight
    var textColor: Color
    var isTextMovement: Bool
    
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize)).fontWeight(fontStyle)
            .foregroundColor(textColor)
            .padding(4)
            .background(isTextMovement ? Color.white.opacity(0.3) : Color.clear)
            .cornerRadius(6)
    
    }
}



