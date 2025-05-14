//
//  FirstEditorView.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/7/25.
//

import SwiftUI
import PencilKit


struct FirstEditorView : View {
    @StateObject private var viewModel = FirstEditionViewModel()
    
    
    @State private var toolPicker = PKToolPicker()
    

    var body: some View {
        NavigationStack {
        VStack(spacing: 0) {
            TabView(selection: $viewModel.activeTab) {
                VStack {
                    ZStack {
                        PictureFrame()
                        
                        if viewModel.imageForProcess != nil {
                            if !viewModel.scaleRotate {
                                DrawingCanvas(canvasView: viewModel.canvasView, toolPicker: $toolPicker, showToolPicker: viewModel.showToolDrawing, viewModel: viewModel)
                                    .padding(.all, 8)
                            }
                        }
                    }

                    
                }
                .setUpTab(.drawing)
                

                VStack {
                    ZStack {
                        PictureFrame()
                        
                    }
                    
                }
                .setUpTab(.texts)
                
                
                VStack{
                    PictureFrame()
                }
                .setUpTab(.filters)
                
            }
            
            switch viewModel.activeTab {
            case .drawing:
                EmptyView()
            case .texts:
                switch viewModel.textOption {
                    
                case "Style":
                    Picker("TextStyle", selection: $viewModel.fontWeight) {
                        ForEach(viewModel.fontWeightNames, id: \.weight) { item in
                            Text(item.name).tag(item.weight)
                        }
                    }
                    .modifier(pickerTintColor())
                    .padding(.all, 5)
                    .modifier(backgroundGray6())
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                case "Size":
                    
                    VStack {
                        Slider(value: $viewModel.textSize, in: 5...50, onEditingChanged: { onEditing in
                            viewModel.isTextEditing = onEditing
                        })
                        .tint(.purple)
                        Text("Size: \(Int(viewModel.textSize))")
                            .font(.caption)
                            .scaleEffect(viewModel.isTextEditing ? 1.2 : 1)
                            .foregroundStyle(viewModel.isTextEditing ? .green : .secondary)
                    }
                    .padding(.horizontal)
                    .opacity(viewModel.textOption == "Size" ? 1 : 0)
                
                case "Color":
                    Picker("TextColor", selection: $viewModel.textColor) {
                        ForEach(viewModel.defaultColors, id: \.marker) { item in
                            Text(item.name).tag(item.marker)
                                
                        }
                    }
                    .modifier(pickerTintColor())
                    .padding(.all, 5)
                    .modifier(backgroundGray6())
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                default:
                    EmptyView()
                }
                
                // Text`s options
                Picker("Text`s options", selection: $viewModel.textOption) {
                    ForEach(viewModel.arrayTextOptions, id: \.self) { option in
                        Text(option).tag(option)
                            
                    }
                }
                .pickerStyle(.segmented)
                .padding([.top])
                
            case .filters:
                VStack {
                    Slider(value: $viewModel.filterIntensity) { onEditing in
                        viewModel.isFilterIntensityEditing = onEditing
                    }
                        .tint(.purple)
                    
                        Text("Intensity")
                            .font(.caption)
                            .scaleEffect(viewModel.isFilterIntensityEditing ? 1.2 : 1)
                            .foregroundStyle(viewModel.isFilterIntensityEditing ? .green : .secondary)
                        
                    Slider(value: $viewModel.filterRadius, in: 0...1000) { onEditing in
                        viewModel.isFilterRadiusEditing = onEditing
                    }
                        .tint(.purple)
                    
                        Text("Radius")
                        .font(.caption)
                        .scaleEffect(viewModel.isFilterRadiusEditing ? 1.2 : 1)
                        .foregroundStyle(viewModel.isFilterRadiusEditing ? .green : .secondary)
                    
                    Picker("Change Filter", selection: $viewModel.selectedFilterName) {
                        ForEach(viewModel.newfilters) { item in
                            Text(item.name).tag(item.name)
                        }
                    }
                    .modifier(pickerTintColor())
                    .modifier(backgroundGray6())
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .onChange(of: viewModel.selectedFilterName) {_ , newValue in
                        viewModel.setFilter(selectedFilterName: newValue)
                    }
                }
                .padding([.horizontal, .bottom])
                    
                
            }
            
        
            CustomTabBar()
                .overlay(alignment: .top) {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(Color.gray)
                        .opacity(0.5)
                    
                }
        }
        .navigationTitle(viewModel.activeTab.title)
        .navigationBarTitleDisplayMode(.large)
            
        .alert("Save to Gallery", isPresented: $viewModel.isSaveToGallery, actions: {
            Button("OK", role: .none) {
                viewModel.savingToGallery()
            }
            
            Button("Cancel", role: .cancel) {}
            
        }, message: {
            Text("Would you like to save your processed Image to Gallery?")
        })
            
        .overlay(alignment: .top, content: {
            Group {
                if viewModel.isShowToastofSavedImage {
                    ToastView(message: viewModel.toastMessage)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    viewModel.isShowToastofSavedImage = false
                                }
                            }
                        }
                        .padding(.top, 20)
                } else if viewModel.ResetImageChanges {
                    ToastView(message: "🧹 It`s cleaned")
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation {
                                    viewModel.ResetImageChanges = false
                                }
                            }
                        }
                        .padding(.top, 20)
                }
            }
        })
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(image: $viewModel.imageForProcess)
            
        }
        .onChange(of: viewModel.imageForProcess) {
            if viewModel.isKeepingOriginalImage {
                viewModel.imageBeforeAllProcessions = viewModel.imageForProcess
                viewModel.isKeepingOriginalImage = false
            }
            if !viewModel.isFilterEditing {
                viewModel.imageBeforeFilteredImage = viewModel.imageForProcess
            }
        }
        .onChange(of: viewModel.ResetImageChanges) {
            if viewModel.ResetImageChanges {
                viewModel.imageForProcess = viewModel.imageBeforeAllProcessions
                viewModel.imageBeforeFilteredImage = viewModel.imageBeforeAllProcessions
                viewModel.clearCanvas() // for drawing
            }
        }
        .onChange(of: viewModel.activeTab) {
            if viewModel.activeTab != .texts {
                viewModel.hideTextZeroOffset()
            }
            
            if viewModel.activeTab != .filters {
                viewModel.isFilterEditing = false
            }
        }
        
        
    
    }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
//                    viewModel.resetTrigger = UUID()
                    viewModel.ResetImageChanges.toggle()
                } label: {
                    Image(systemName: "trash")
                }
                .tint(Color.purple)
                
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.showingImagePicker = true
                    viewModel.isFilterEditing = false
                    viewModel.isKeepingOriginalImage = true
                } label: {
                    Image(systemName: "photo.on.rectangle.angled")
                }
                .tint(Color.purple)
                .disabled(viewModel.imageForProcess != nil ?  false : true)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.scaleRotate.toggle()
                } label: {
                    Image(systemName: "plus.arrow.trianglehead.clockwise")
                }
                .tint(viewModel.scaleRotate ? Color.green : Color.black)
                .scaleEffect(viewModel.scaleRotate ? 1.2 : 1)
            }
            
            
            if viewModel.activeTab == .drawing || viewModel.activeTab == .texts {
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        if viewModel.activeTab == .drawing {
                            viewModel.showToolDrawing.toggle()
                        } else {
                            if viewModel.isTextAppeard {
                                viewModel.hideTextZeroOffset()
                            } else {
                                viewModel.isTextAppeard = true
                            }
                        }
                    }) {
                        Label("HideShow", systemImage: viewModel.activeTab == .drawing ? "pencil.and.scribble" : "character.cursor.ibeam")
                            .labelStyle(.titleAndIcon)
                    }
                    .tint(viewModel.StateDrawTextInstruments ? Color.green : Color.black)
                    .scaleEffect(viewModel.StateDrawTextInstruments ? 1.2 : 1)
                }
            }
            
            if viewModel.activeTab == .texts  {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action : {
                        guard let image = viewModel.imageForProcess else { return }
                        
                        if viewModel.activeTab == .texts {
                            // for text
                            viewModel.textIsAccepted = true
                            viewModel.imageForProcess = viewModel.renderingImage(from: image, canvasView: viewModel.canvasView, size: image.size)
                        }
                        
                        if viewModel.activeTab == .filters {
                            
                        }
                        
                        
                    }) {
                        Label("Adding", systemImage: "checkmark")
                    }
                    .tint(Color.black)
                    .disabled(viewModel.StateDrawTextInstruments ? false : true)
                }
            }
            
            if viewModel.activeTab == .filters {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.isFilterEditing = true
                            viewModel.loadImageForFilter()
                        
                    } label: {
                        Image(systemName: "wand.and.rays")
                    }
                    .disabled(viewModel.imageForProcess == nil ? true : false)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.isSaveToGallery.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                }
                .tint(Color.purple)
                .scaleEffect(1.5)
            }
        }

    }
    
   @ViewBuilder
    func PictureFrame() -> some View {
        GeometryReader { geo in
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.gray)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 2)

                        }
                    
                    if let image = viewModel.imageForProcess {
                        
                        ScalableRotatableImage(image: image, scaleRotate: $viewModel.scaleRotate, isReseting: viewModel.ResetImageChanges)
                        
                        EditableTextOverlay(
                            text: $viewModel.addedText,
                            fontSize: $viewModel.textSize,
                            fontStyle: $viewModel.fontWeight,
                            textColor: $viewModel.textColor,
                            isTextMovement: $viewModel.isTextDragging, offset: $viewModel.textOffset)
                        .opacity(viewModel.isTextAppeard ? 1 : 0)
                        .frame(width: geo.size.width - 30) // for the text`s width size
                    } else {
                        Text("Tap to select a picture")
                            .foregroundStyle(Color.white)
                            .font(.headline)
                    }
                    
                    if viewModel.isFilterEditingProgress {
                        ProgressView()
                            .scaleEffect(2.0)
                            .progressViewStyle(.circular)
                            .tint(Color.purple)
                    }
                    
                }
            }
            .onAppear {
                print("PictureFrame size: \(geo.size)")
                        viewModel.pictureFrameSize = geo.size  // Save it if needed
                    }
        }
        // other child content inside cannot be overlayed this parent frame
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.all, 8)

        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded { value in
                    
                    if viewModel.imageForProcess == nil {
                        viewModel.showingImagePicker = true
                    } else {
                        if viewModel.activeTab == .texts {
                            viewModel.isTextAppeard = true
                        }
                    }
                        
                }
        )
    }
    
    
    @ViewBuilder
    private func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach($viewModel.allTabs) { $animatedTab in
                let tab = animatedTab.tab
                
                VStack(spacing: 4) {
                    Image(systemName: tab.rawValue)
                        .font(.title2)
                        .symbolEffect(.bounce.down.byLayer, options: .nonRepeating, value: animatedTab.isAnimating)
                        .foregroundColor(viewModel.activeTab == tab ? .purple : .gray)
                        
            
                    Text(tab.title)
                        .font(.caption)
                        .textScale(.default)
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(viewModel.activeTab == tab ? Color.primary : Color.gray)
                .scaleEffect(viewModel.activeTab == tab ? 1.2 : 1.0)
                .padding(.top, 15)
                .padding(.bottom, 10)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete, {
                        viewModel.activeTab = tab
                        animatedTab.isAnimating = true
                    }) {// this is our completion
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            animatedTab.isAnimating = nil
                        }
                    }
                }
            }
        }
        .background(.bar)
        
    }
}

#Preview {
    NavigationStack{
        FirstEditorView()
    }
}

extension View {
    @ViewBuilder
    func setUpTab(_ tab: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
    
    
    
}



