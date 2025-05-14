//
//  RegView-ViewModel.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/6/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift

@MainActor class RegViewModel: ObservableObject {
    @Published var RegLogin: String = ""
    @Published var RegPassword: String = ""
    @Published var RegNickName: String = ""
    
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    @Published var isLoading = false
    
    
    
    // Main user registration method
    func registerUser() async {
        guard !RegLogin.isEmpty, !RegPassword.isEmpty else {
            errorMessage = "Email and password cannot be empty!"
            showErrorAlert = true
            return
        }
        
        isLoading = true
        // it`s gonna be reset to false automatically
        defer { isLoading = false }
        
        do {
            // it creates user
            let result = try await Auth.auth().createUser(withEmail: RegLogin, password: RegPassword)
            print("Registered user:", result.user.uid)
            
            
            // sending email - varification
            try await result.user.sendEmailVerification()
            print("Varification email sent")
            
        } catch let error as NSError {
            switch AuthErrorCode(rawValue: error.code) {
            case .emailAlreadyInUse:
                errorMessage = "This email is already in use."
            case .invalidEmail:
                errorMessage = "The email address is invalid."
            case .weakPassword:
                errorMessage = "Password must be at least 6 characters."
            default:
                errorMessage = error.localizedDescription
            }
            // if we`ve got error here
            showErrorAlert = true
        }
    }
    
}
