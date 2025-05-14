//
//  filterItemModel.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/13/25.
//

import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins

struct NamedFilter: Identifiable {
    let id = UUID()               // For `ForEach` ID
    let name: String              // Shown in Picker
    let create: () -> CIFilter    // Closure to create the actual filter
}
