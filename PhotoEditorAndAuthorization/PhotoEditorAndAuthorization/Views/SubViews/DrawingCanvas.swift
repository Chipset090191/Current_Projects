//
//  DrawingCanvas.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/10/25.
//

import SwiftUI
import PencilKit

struct DrawingCanvas: UIViewRepresentable {
    var canvasView: PKCanvasView
    @Binding var toolPicker: PKToolPicker
    var showToolPicker: Bool
    var viewModel: FirstEditionViewModel
    
    
    func makeUIView(context: Context) -> some UIView {
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = UIColor.clear
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        canvasView.layer.cornerRadius = 12
        
        
        
        // delegate Coordinator for sending data to FirstEditionViewModel
        canvasView.delegate = context.coordinator
        
        return canvasView
    
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        toolPicker.setVisible(showToolPicker, forFirstResponder: canvasView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        let viewModel: FirstEditionViewModel
        
        init(viewModel: FirstEditionViewModel) {
            self.viewModel = viewModel
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            viewModel.canvasViewDrawingDidChange(canvasView)
            
        }
        
    }
    
    

   

}

