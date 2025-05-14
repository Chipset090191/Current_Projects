//
//  FirstEditorView-ViewModel.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/7/25.
//
import SwiftUI
import PencilKit
import CoreImage
import CoreImage.CIFilterBuiltins


@MainActor class FirstEditionViewModel: NSObject ,ObservableObject {
    
    
    @Published var activeTab: Tab = .texts
    
    @Published var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab in
        return .init(tab: tab)
    }
    @Published var showingImagePicker = false
    @Published var isSaveToGallery = false
    @Published var isShowToastofSavedImage = false
    @Published var toastMessage: String = ""
    @Published var imageForProcess: UIImage?
    @Published var imageBeforeAllProcessions: UIImage?
    @Published var pictureFrameSize: CGSize = .zero
    
    //Texts
    @Published var isTextOverlayVisible: Bool = false
    @Published var textOption = "Style"
    let arrayTextOptions = ["Style", "Size", "Color"]
    @Published var addedText = "Sample text"
    @Published var textSize: CGFloat = 24
    @Published var fontWeight: Font.Weight = .semibold
    @Published var textColor: Color = Color.purple
    @Published var textOffset: CGSize = .zero
    @Published var isTextEditing = false
    
    
    //Common
    @Published var resetTrigger = UUID()
    @Published var scaleRotate = false
    @Published var ResetImageChanges = false
    @Published var isKeepingOriginalImage = true
    @Published var isTextDragging = false
    @Published var isTextAppeard = false
    @Published var textIsAccepted = false
    @Published var showToolDrawing = true
    
    //Filters
    @Published var imageBeforeFilteredImage: UIImage?
    @Published var filterIntensity = 0.5
    @Published var filterRadius = 20.0
    @Published var isFilterEditing = false
    @Published var isFilterEditingProgress = false
    @Published var isFilterIntensityEditing = false
    @Published var isFilterRadiusEditing = false
    @Published var imageIsDownloadedForFiltering = false
    @Published var currentFilter: CIFilter = CIFilter.sepiaTone() // default filter
    @Published var selectedFilterName: String = "Sepia Tone"
    
    // Drawing
    @Published var canvasView = PKCanvasView()
    
    // Filtering
    let context = CIContext()
    
    var StateDrawTextInstruments: Bool {
        if activeTab == .texts {
            return isTextAppeard
        } else if activeTab == .drawing {
            return showToolDrawing
        }
        return true
    }
        
    let defaultColors: [(name: String, marker: Color)] = [
        ("black", .black),
        ("white", .white),
        ("red", .red),
        ("green", .green),
        ("blue", .blue),
        ("yellow", .yellow),
        ("orange", .orange),
        ("pink", .pink),
        ("purple", .purple),
        ("gray", .gray),
        ("brown", .brown),
        ("mint", .mint),
        ("indigo", .indigo),
        ("cyan", .cyan),
        ("teal", .teal)
    ]
    

    let fontWeightNames: [(name: String, weight: Font.Weight)] = [
        ("Ultra Light", .ultraLight),
        ("Thin", .thin),
        ("Light", .light),
        ("Regular", .regular),
        ("Medium", .medium),
        ("Semibold", .semibold),
        ("Bold", .bold),
        ("Heavy", .heavy),
        ("Black", .black)
    ]
    
    //filters
    let newfilters: [NamedFilter] = [
            NamedFilter(name: "Crystallize", create: { CIFilter.crystallize() }),
            NamedFilter(name: "Edges", create: { CIFilter.edges() }),
            NamedFilter(name: "Gaussian Blur", create: { CIFilter.gaussianBlur() }),
            NamedFilter(name: "Pixellate", create: { CIFilter.pixellate() }),
            NamedFilter(name: "Sepia Tone", create: { CIFilter.sepiaTone() }),
            NamedFilter(name: "Unsharp Mask", create: { CIFilter.unsharpMask() }),
            NamedFilter(name: "Vignette", create: { CIFilter.vignette() }),
            NamedFilter(name: "Bloom", create: { CIFilter.bloom() }),
            NamedFilter(name: "Bump Distortion", create: { CIFilter.bumpDistortion() }),
            NamedFilter(name: "Color Inversion", create: { CIFilter.colorInvert() })
        ]
    
    func uiFontWeight(from fontWeight: Font.Weight) -> UIFont.Weight {
        switch fontWeight {
        case .ultraLight: return .ultraLight
        case .thin:       return .thin
        case .light:      return .light
        case .regular:    return .regular
        case .medium:     return .medium
        case .semibold:   return .semibold
        case .bold:       return .bold
        case .heavy:      return .heavy
        case .black:      return .black
        default:          return .regular
        }
    }
    
    
    
    func setFilter(selectedFilterName: String) {
        if let selected = newfilters.first(where: { $0.name == selectedFilterName }) {
            currentFilter = selected.create()
        }

    }
    

    

    func hideTextZeroOffset() {
        isTextAppeard = false
        textOffset = .zero
    }
    
    
    func savingToGallery() {
        if let imageProcessed = imageForProcess {
            UIImageWriteToSavedPhotosAlbum(imageProcessed, self, #selector(saveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        
    }
    

    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer?) {
        if let error = error {
            print("Save failed: \(error.localizedDescription)")
            self.toastMessage = "❌ Save failed: \(error.localizedDescription)"
        } else {
            print("Image saved successfully!")
            self.toastMessage = "✅ Image saved successfully!"
        }
        isShowToastofSavedImage = true
    }

    
    func clearCanvas() {
                self.canvasView.drawing = PKDrawing()
    }

    func renderingImage(from base: UIImage, canvasView: PKCanvasView, size: CGSize) -> UIImage? {
        
    
        return autoreleasepool { // Prevents memory buildup when rendering multiple times or with large images
            let imageSize = base.size
            let scale = base.scale
            print ("Image size: \(imageSize)")
            
            if textIsAccepted {
                guard pictureFrameSize != .zero else {
                    print("❌ Invalid pictureFrameSize")
                    return nil
                }
                
                // Convert SwiftUI Color to UIColor
                let uiColor = UIColor(textColor)
                
                let uiFont = uiFontWeight(from: fontWeight)
                
                
                // Calculate scale ratios
                let xRatio = imageSize.width / pictureFrameSize.width
                let yRatio = imageSize.height / pictureFrameSize.height
                
                // Scale offset
                let scaledOffset = CGSize(
                    width: textOffset.width * xRatio,
                    height: textOffset.height * yRatio
                )
                
                print("Scaled offset height: \(scaledOffset.height)")
                
                // Start graphics context
                UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
                
                
                // Draw base image
                base.draw(in: CGRect(origin: .zero, size: imageSize))
                
                
                // Draw text
                let textAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: textSize * xRatio, weight: uiFont), // Scale font size too
                    .foregroundColor: uiColor
                ]
                
                let y = (imageSize.height - textSize * xRatio * 0.9) / 2 + scaledOffset.height
                let textPoint = CGPoint(x: scaledOffset.width, y: y)
                
                
                
                print("textPoint: \(textPoint)")
                (addedText as NSString).draw(at: textPoint, withAttributes: textAttributes)
                
                // Get final image
                let finalImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                print("got it!")
                textIsAccepted = false
                return finalImage
            } else {
                
                let renderer = UIGraphicsImageRenderer(size: size)
                
                
                return renderer.image { context in
                    base.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    
                    let canvasImage = canvasView.drawing.image(from: canvasView.bounds, scale: 1.0)
                    print("Canvas Bounds: \(canvasView.bounds)")
                    
                    canvasImage.draw(in: CGRect(origin: .zero, size: size))
                    
                }
            }
        }
    
        
    }
    
    
    func loadImageForFilter() {
        isFilterEditingProgress = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.imageForProcess = self.imageBeforeFilteredImage
            guard let inputImageForFilter = self.imageForProcess else { return }
            
            let fixedImage = self.fixOrientation(of: inputImageForFilter)
            
            let beginImage = CIImage(image: fixedImage)
            
            self.currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            
            self.applyFilterProcessing()
            self.isFilterEditingProgress = false
        }
    }
    
    
    func applyFilterProcessing() {
        
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: (imageForProcess?.size.width)! / 2.0, y: (imageForProcess?.size.height)! / 2.0), forKey: kCIInputCenterKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            imageForProcess = uiImage
        }
        
    }
    
    
    func fixOrientation(of image: UIImage) -> UIImage {
        if image.imageOrientation == .up {
            return image
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }

    


    func forRendereing(){
        guard let inputImage = imageForProcess else { return }
        self.imageForProcess = renderingImage(from: inputImage, canvasView: canvasView, size: inputImage.size)
        
    }
    
    

}

extension FirstEditionViewModel: PKCanvasViewDelegate {

    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        forRendereing()
        
    }
    
}
