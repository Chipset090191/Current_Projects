//
//  ScalableRotatableImage.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/9/25.
//

import SwiftUI

struct ScalableRotatableImage: View {
    var image: UIImage
    
    
    @State private var currentScale: CGFloat = 0.0
    @State private var finalScale: CGFloat = 1.0
    @State private var currentRotation: Angle = .zero
    @State private var finalRotation: Angle = .zero
    
    @State private var isInteracting: Bool = false
    @Binding var scaleRotate: Bool
    var isReseting: Bool
    
    var body: some View {
        
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .scaleEffect(currentScale + finalScale)
            .rotationEffect(currentRotation + finalRotation)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay{
                RoundedRectangle(cornerRadius: 0)
                    .stroke(style: StrokeStyle(lineWidth: 8, dash: [6]))
                    .foregroundStyle(isInteracting ? Color.green : Color.clear)
            }
            .onChange(of: isReseting) {
                if isReseting {
                    currentScale = 0.0
                    finalScale = 1.0
                    currentRotation = .zero
                    finalRotation = .zero
                }
            }
            .gesture(
                SimultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            if scaleRotate {
                                isInteracting = true
                                onChangeScale(value: value)
                            }
                        }
                        .onEnded { _ in
                            if scaleRotate {
                                isInteracting = false
                                onEndedScale()
                            }
                        },
                    
                    RotateGesture()
                        .onChanged { angle in
                            if scaleRotate {
                                isInteracting = true
                                currentRotation = angle.rotation
                            }
                        }
                        .onEnded { angle in
                            if scaleRotate {
                                isInteracting = false
                                finalRotation += angle.rotation
                                currentRotation = .zero
                            }
                        }
                )
            )
            .padding(.bottom, 2)
            .padding(.top, 2)
//            .padding(.all, 2)
    }
    
    
    private func onChangeScale(value: CGFloat) {
        if value - 1 <= -0.5 {
            currentScale = -0.5
        } else {
            currentScale = value - 1
            
        }
    }
    
    private func onEndedScale() {
        finalScale += currentScale
        currentScale = 0
        if finalScale <= 0.5 {
            finalScale = 0.5
        }
    }
}


