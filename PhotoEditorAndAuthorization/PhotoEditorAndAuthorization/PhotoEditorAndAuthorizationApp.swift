//
//  PhotoEditorAndAuthorizationApp.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/6/25.
//

import SwiftUI
import Firebase

@main
struct PhotoEditorAndAuthorizationApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
