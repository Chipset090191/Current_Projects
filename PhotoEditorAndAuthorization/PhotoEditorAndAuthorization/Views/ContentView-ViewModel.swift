//
//  ContentView-ViewModel.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/6/25.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

@MainActor class ContentViewModel: ObservableObject {
    
    @Published var loginField: String = ""
    @Published var passwordField: String = ""
    
    @Published var signInSheetOpened = false
    
    @Published var signedUp = false
    @Published var isLoadingbyGoogle = false
    @Published var isLoadingbyEmail = false
    @Published var showAlert = false
    @Published var allertMessage = ""
    @Published var allertHeader = ""
    
    
    
    
    func logIn() async {
        allertHeader = "Warning"
        guard !loginField.isEmpty, !passwordField.isEmpty else {
            print("Email and Passwords are empty!")
            allertMessage = "Email and Passwords are empty"
            showAlert = true
            return
        }
        
        isLoadingbyEmail = true
        defer { isLoadingbyEmail = false }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: loginField, password: passwordField)
            print ("User is logged in: \(result.user.uid)")
            signedUp = true
            
        } catch let error as NSError {
            switch AuthErrorCode(rawValue: error.code) {
            case .invalidEmail:
                print("Invalid email")
                allertMessage = "Invalid email."
            case .wrongPassword:
                print("Wrong password")
                allertMessage = "Wrong password."
            case .userNotFound:
                print("User not found")
                allertMessage = "User not found."
            case .networkError:
                print("Network error")
                allertMessage = "Network error."
            default:
                allertMessage = error.localizedDescription
            }
            showAlert = true
        }
        
        
    }
    
    // Google singing-Up
    func handleGoogleSigningUp() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let rootViewController = windowScene.windows.first(where: {$0.isKeyWindow})?.rootViewController else {
                print("Failed to get rootVC!")
            return
        }
        self.isLoadingbyGoogle = true
        
        
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("Google Sing-In failed: \(error.localizedDescription)")
                self.isLoadingbyGoogle = false
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                print ("No user or ID token")
                self.isLoadingbyGoogle = false
                return
            }
            
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            
            // Sing in with Firebase
            Auth.auth().signIn(with: credential) { authResult, error in
                self.isLoadingbyGoogle = false
                if let error = error {
                    print("Firebase sign-in failed: \(error.localizedDescription)")
                }
                
                // success!
                print("Firebase user signed in: \(authResult?.user.email ?? "unknown")")
                
                self.signedUp = true
            }
            
        }
    }
    
    
    
}
