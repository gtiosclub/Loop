//
//  Login.swift
//  Loop
//
//  Created by Dennis nguyen on 10/1/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Log into your account")
                            .font(.title)
                            .foregroundColor(.black)
                        
                        TextField("Email", text: $email)
                            .padding()
                            .foregroundColor(.gray)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .font(.system(size: 15, weight: .regular))
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .foregroundColor(.gray)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .font(.system(size: 15, weight: .regular))
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        authManager.signIn(email: email, password: password) { success in
                            if !success {
                                self.alertMessage = authManager.errorMessage ?? "Unknown error occurred."
                                self.showAlert = true
                            }
                        }
                    }, label: {
                        Text("Login")
                            .padding()
                            .frame(maxWidth: 170)
                            .foregroundColor(Color.black)
                            .background(Color(.systemGray5))
                            .cornerRadius(50)
                            .bold()
                    })
                    .padding()
                    
                    Button(action: {
                        // Handle Forgot Password action
                    }) {
                        Text("Forgot Password?")
                            .padding(1)
                            .foregroundColor(Color.gray)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(Color.black)
                            .font(.system(size: 15))
                        NavigationLink {
                            // Handle Sign Up action
                            CreateLoginView()
                        } label: {
                            Text("Sign Up")
                                .foregroundColor(Color.blue)
                                .font(.system(size: 15))
                                .bold()
                        }
                    }
                    
                    Spacer()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login Failed"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}
#Preview {
    LoginView()
}
