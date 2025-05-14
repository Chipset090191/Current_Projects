//
//  Untitled.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/13/25.
//
import SwiftUI

extension View {
    func editableTextStyle(fontSize: CGFloat, fontStyle: Font.Weight, textColor: Color, isTextMovement: Bool) -> some View {
        self.modifier(EditableTextModifier(fontSize: fontSize, fontStyle: fontStyle, textColor: textColor, isTextMovement: isTextMovement))
    }
    
}

