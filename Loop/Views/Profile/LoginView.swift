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
    @State private var suqareImage: String = "square"
    @State private var squarefilled: Bool = false
    @State private var isSecure: Bool = true
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.gray)
                    }.offset(x:-180)
                    
                    Spacer()
                   
                        
                        
                        Text("Login to Loop")
                            .font(.title)
                        .foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: -10) {
                       
                        
                        HStack {
                            TextField("Email Address", text: $email)
                                .padding(.trailing, 32)
                                .autocapitalization(.none)
                    
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding()
                        
                       HStack {
                           if (isSecure) {
                               SecureField("Password", text: $password)
                                   .padding(.trailing, 32) // Add padding to leave space for the button
                                   .autocapitalization(.none)
                           } else {
                               TextField("Password", text: $password)
                                   .padding(.trailing, 32)
                                   .autocapitalization(.none)
                           }
                           
                           Button(action: {
                               isSecure.toggle()
                           }) {
                               Image(systemName: isSecure ? "eye.slash" : "eye")
                                   .foregroundColor(.gray)
                           }
                           .padding(.trailing, 8) // Add padding to align within the field
                       }
                       .padding()
                       .background(Color(.secondarySystemBackground))
                       .cornerRadius(14)
                       .overlay(
                           RoundedRectangle(cornerRadius: 14)
                               .stroke(Color.gray, lineWidth: 1)
                       )
                       .padding()
                        
                        
                    }
                    .padding(.horizontal)
                    HStack {
                        
                        Button(action: {
                            squarefilled.toggle()
                            
                        }, label: {
                            HStack {
                                Image(systemName: squarefilled ? "checkmark.square.fill" : "square")
                                Text("Remember Me")
                            }
                        })
                        .padding()
                        .foregroundColor(squarefilled ? .black : .gray)
                        
                        
                        Spacer()
                        
                        Button(action: {
                            //Forgot Password goes here
                            print("Forgot Password?")
                            
                        }, label: {
                            HStack {
                                Text("Forgot Password")
                            }
                        })
                        .padding()
                        .foregroundColor(.red)
                        
                    }
                    
                    
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
                            .frame(maxWidth: 700)
                            .foregroundColor(Color.white)
                            .bold()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                           .fill(Color.red)
                                           .frame(maxWidth: 100000) // Match this width to make the rectangle longer
                                   )
                                   .cornerRadius(10) // Move this modifier outside the Text for the desired effect
                    })
                    .padding()
                    
                  
                        
                    
                    Spacer()
                    
                    HStack {
                        Rectangle()
                            .frame(height: 1.5) // Adjust thickness here
                            .foregroundColor(.gray) // Adjust color here
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10)
                    .offset(y: 100)
                    
                    HStack {
                        
                        Text("Don't have an account?")
                            .foregroundColor(Color.black)
                            .font(.system(size: 15))
                            .offset(y:100)
                        NavigationLink {
                            // Handle Sign Up action
                            CreateLoginView()
                        } label: {
                            Text("Sign Up")
                                .font(.system(size: 15))
                                .bold()
                                .foregroundColor(.red)
                        }.offset(y:100)
                    }
                    
                    Spacer()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login Failed"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        } .navigationBarBackButtonHidden(true)
    }
       
}

#Preview {
    LoginView()
}
