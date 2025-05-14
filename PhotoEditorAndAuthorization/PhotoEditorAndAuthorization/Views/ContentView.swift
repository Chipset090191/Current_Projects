//
//  ContentView.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/6/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

enum Field {
    case email
    case password
}

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    @FocusState private var focuseField: Field?
    
    @FocusState private var isEmailOrPasswordTapped: Bool
    
    var body: some View {
        NavigationStack{
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 200, height: 200) // Adjust as needed
                    .overlay{
                        Image("startedScreenPhoto")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .scaleEffect(isEmailOrPasswordTapped ? 0.5 : 1)
                    .animation(.easeInOut, value: isEmailOrPasswordTapped)
                
                Spacer()
                Text("💔 Your Lovely Photo Editor")
                    .font(.system(size: 24, weight: .medium, design: .serif))
                    .italic()
                Spacer()
                
                VStack(spacing: 15) {
                    
                    TextField("Email", text: $viewModel.loginField)
                        .padding()
                        .focused($focuseField, equals: .email)
                        .focused($isEmailOrPasswordTapped)
                        
                        .onSubmit{
                            focuseField = .password
                        }
                        .overlay{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black,lineWidth: 2)
                        }
                        .modifier(ConditionalBackground(isTapped: isEmailOrPasswordTapped))
                        .cornerRadius(8)
                        
                    
                    
                    SecureField("Password", text: $viewModel.passwordField)
                        .padding()
                        .focused($focuseField, equals: .password)
                        .focused($isEmailOrPasswordTapped)
                        .overlay{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black,lineWidth: 2)
                        }
                        .modifier(ConditionalBackground(isTapped: isEmailOrPasswordTapped))
                        .cornerRadius(8)
                    
                    HStack(spacing: 20){
                        ZStack {
                            Button {
                                Task {
                                    await viewModel.logIn()
                                }
                            } label: {
                                Text("Log in")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 24)
                                    .background(Color.accentColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .disabled(viewModel.isLoadingbyEmail ? true : false)
                            if viewModel.isLoadingbyEmail {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(Color.white)
                            }
                        }
                        Button {
                            viewModel.signInSheetOpened.toggle()
                        } label: {
                            Text("Sign-In")
                                .foregroundColor(.accentColor)
                                .font(.system(size: 16, weight: .regular))
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.accentColor, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.top, 15)
                    VStack{
                        Text("Google Sign-In")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        ZStack {
                            GoogleSignInButton(style: .icon) {
                                viewModel.handleGoogleSigningUp()
                            }
                            .opacity(viewModel.isLoadingbyGoogle ? 0.3 : 1)
                            .disabled(viewModel.isLoadingbyGoogle ? true : false)
                            if viewModel.isLoadingbyGoogle {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.blue)
                            }
                        }
                    }
                    
                }
                .padding(.horizontal, 30)
                Spacer()
                Spacer()
                
            }
            .background(AngularGradient(gradient:
                        Gradient(
                            colors: [.red, .yellow, .green, .blue, .purple, .red]),
                            center: .center
                                )
                       .ignoresSafeArea()
                       .blur(radius: 1))
            .frame(maxHeight: .infinity, alignment: .top)
            .sheet(isPresented: $viewModel.signInSheetOpened) {
                RegView() { nickName in
                    viewModel.allertHeader = "Success"
                    viewModel.allertMessage = "Welcome to G.O.A.T. editor my friend \(nickName)"
                    viewModel.showAlert = true
                }
            }
            .alert(viewModel.allertHeader, isPresented: $viewModel.showAlert) {
                Button("OK") {
                    if viewModel.allertHeader.contains("Success") {
                        viewModel.signedUp = true
                    }
                }
            } message: {
                Text(viewModel.allertMessage)
            }
                
            .navigationDestination(isPresented: $viewModel.signedUp) {
                FirstEditorView().navigationBarBackButtonHidden()
            }
//            .onAppear{
//                #warning("delete this")
//                viewModel.signedUp = true
//            }
        }
        
        
        
    }
}

#Preview {
    ContentView()
}
