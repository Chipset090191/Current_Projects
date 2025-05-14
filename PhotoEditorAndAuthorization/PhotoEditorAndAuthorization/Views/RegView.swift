//
//  RegView.swift
//  PhotoEditorAndAuthorization
//
//  Created by Mikhail Tikhomirov on 5/6/25.
//

import SwiftUI


struct RegView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = RegViewModel()
    
    var onRegisterSuccess: (_ nickName: String) -> Void
    
    var body: some View {
        VStack(spacing: 24) {
                    // Title
                    Text("Create an Account")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.top, 40)
            
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Enter your nickname(optional)", text: $viewModel.RegNickName)
                            .padding()
                            .modifier(backgroundGray6())
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.secondary, lineWidth: 1)
                            )
                            .cornerRadius(8)
                            
                    }
            
                    // Email Label
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        TextField("Enter your email", text: $viewModel.RegLogin)
                            .padding()
                            .modifier(backgroundGray6())
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.secondary, lineWidth: 1)
                            )
                            .cornerRadius(8)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }

                    // Password Label
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        SecureField("Enter your password", text: $viewModel.RegPassword)
                            .padding()
                            .modifier(backgroundGray6())
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.secondary, lineWidth: 1)
                            )
                            .cornerRadius(8)
                    }

                    // Register Button
            
                     ZStack {
                        Button(action: {
                            Task {
                                await viewModel.registerUser()
                                if !viewModel.showErrorAlert {
                                    onRegisterSuccess(viewModel.RegNickName)
                                    dismiss()
                                }
                            }
                        }) {
                            Text(viewModel.isLoading ?  " " : "Register")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.isLoading)

                        
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.blue)
                        }
                    }
                      .padding(.top, 20)
            
                
                Spacer()
                }
                .padding(.horizontal, 24)
                .frame(maxHeight: .infinity, alignment: .top)
                .background(Color(.systemBackground))
                .alert("Warning", isPresented: $viewModel.showErrorAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text (viewModel.errorMessage)
                }
    }
}

#Preview {
    RegView(onRegisterSuccess: {nickName in })
}
