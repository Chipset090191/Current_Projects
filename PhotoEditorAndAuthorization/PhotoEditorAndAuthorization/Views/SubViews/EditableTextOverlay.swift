//
//  EditableTextOverlay.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/9/25.
//

import SwiftUI


struct EditableTextOverlay: View {
    @Binding var text: String
    @Binding var fontSize: CGFloat
    @Binding var fontStyle: Font.Weight
    @Binding var textColor: Color
    @Binding var isTextMovement: Bool
//    @Binding var position: CGPoint
    @Binding var offset: CGSize
    @State private var dragOffset: CGSize = .zero
    
    
    var body: some View {
        TextField("", text: $text)
//            .editableTextStyle(fontSize: fontSize, fontStyle: fontStyle, textColor: textColor, isTextMovement: isTextMovement)
            .font(.system(size: fontSize)).fontWeight(fontStyle)
            .foregroundColor(textColor)
            .padding(4)
            .background(isTextMovement ? Color.white.opacity(0.3) : Color.clear)
            .cornerRadius(6)
            .offset(CGSize(
                width: offset.width + dragOffset.width,
                height: offset.height + dragOffset.height)
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        print ("My offset is \(offset)")
                        dragOffset = value.translation
                        isTextMovement = true
                    }
                    .onEnded { value in
                        offset = CGSize(
                            width: offset.width + value.translation.width,
                            height: offset.height + value.translation.height)
                        dragOffset = .zero
                        isTextMovement = false
                    }
            )
    }
    
    

    
}


