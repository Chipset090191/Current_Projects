//
//  ImagePicker.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/9/25.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
                                                                //    swiftUI View
                                                               // NSObject - query information what we wanna do next after actions that user applies
                                                            // PHPickerViewControllerDelegate - it makes our Coordinator`s context conform to PHPickerViewController
        @Binding var image:UIImage?
        
        
        
        class Coordinator:NSObject,PHPickerViewControllerDelegate {
            var parent: ImagePicker
            
            init(parent: ImagePicker) {
                self.parent = parent
            }
            
            // [PHPickerResult] - that result an array whether user`s chosen smth or not.
            
            // did FinishPicking implementation is called when the user chosen the photo or we press cancel
            func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
                picker.dismiss(animated: true) {
                
                    guard let provider = results.first?.itemProvider else { return }
                    
                    if provider.canLoadObject(ofClass: UIImage.self) {
                        provider.loadObject(ofClass: UIImage.self) { image, _ in
                            DispatchQueue.main.async {
                                           self.parent.image = image as? UIImage
                            }
                        }
                    }
                    
                }
            }
                
        }
        
        // we do not need the body because the body here will be UIcontroller itself
        
        func makeUIViewController(context: Context) -> PHPickerViewController {
            var config = PHPickerConfiguration()
            config.filter = .images                                             // we say just give us an images
            
            let picker = PHPickerViewController(configuration: config)          // and put that into ViewController
            
            picker.delegate = context.coordinator                               // this step we implemented our coordinator to picker through delegate to coordinate next step!
            
            return picker // here it selects images for us
        }
        
        func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
            
        }
        
        func makeCoordinator() -> Coordinator {   // Coordinator helps us to construct the bridge between swiftUI and UIKit
            Coordinator(parent: self)   // so here we are passing the ImagePicker struct and + our Binding to modify it inside our Coordinator
        }
}

