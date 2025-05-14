//
//  PictureFrameView.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/9/25.
//

import SwiftUI

struct PictureFrameView1: View {
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(.gray)
                
                Text("Tap to select a picture")
                    .foregroundStyle(Color.white)
                    .font(.headline)
            }
        }
        .padding([.horizontal, .bottom])
        
    }
}

#Preview {
    PictureFrameView1()
}
