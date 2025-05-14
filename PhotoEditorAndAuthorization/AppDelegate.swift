//
//  AppDelegate.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/6/25.
//

import UIKit
import Firebase
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
           FirebaseApp.configure()
           return true
       }
    
    // This is needed for Google Sign-In to work correctly
      func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
          return GIDSignIn.sharedInstance.handle(url)
      }
}
