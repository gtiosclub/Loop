//
//  ChangePassword.swift
//  Loop
//
//  Created by Dennis nguyen on 10/3/24.
//





import SwiftUI

struct ChangePasswordView: View {
    @State var NewPassword: String = ""
    @State var Password: String = ""
    @State var ConfirmPassword: String = ""
    @State var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State var showAlertForDifferentPassword: Bool = false
    @State var alertmessage : String = ""
    @State var alerTitle: String = ""
    @State var ConfirmPasswordFilled :Bool = false
    @State var NewPasswordFilled :Bool = false
    @State var CurrentPasswordFilled :Bool = false
    @State var EverythingIsfilled: Bool = false
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(.red)
        }
        .offset(x: -150)
        .navigationBarBackButtonHidden(true)


        

        VStack {
            
            Text("Change Your Password")
                    .foregroundStyle(.black)
            
            TextField("Current Password",text: $Password) // maybe make this a secure field
                    .autocapitalization(.none)
                    .padding(8).background(Color.red.opacity(0.3))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onChange(of: Password, initial: true) {
                        if (Password == "") {
                            CurrentPasswordFilled = false
                        } else {
                            CurrentPasswordFilled = true
                        }
                        if (CurrentPasswordFilled && NewPasswordFilled && ConfirmPasswordFilled) {
                            EverythingIsfilled = true
                        } else {
                            EverythingIsfilled = false
                        }
                       
                    }
                   
                
                
            TextField("New Password", text: $NewPassword) //maybe make this a secure field
                    .autocapitalization(.none)
                    .padding(8).background(Color.red.opacity(0.3))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onChange(of: NewPassword, initial: true) {
                        if (NewPassword == "") {
                            NewPasswordFilled = false
                        } else {
                            NewPasswordFilled = true
                        }
                        if (CurrentPasswordFilled && NewPasswordFilled && ConfirmPasswordFilled) {
                            EverythingIsfilled = true
                        } else {
                            EverythingIsfilled = false
                        }
                       
                       
                    }
                
                
            SecureField("Confirm Password", text: $ConfirmPassword)
                    .autocapitalization(.none)
                    .padding(8).background(Color.red.opacity(0.3))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onChange(of: ConfirmPassword, initial: true) {
                        if (ConfirmPassword == "") {
                            ConfirmPasswordFilled = false
                        } else {
                            ConfirmPasswordFilled = true
                        }
                        if (CurrentPasswordFilled && NewPasswordFilled && ConfirmPasswordFilled) {
                            EverythingIsfilled = true
                        } else {
                            EverythingIsfilled = false
                        }
                    }
                
                
                   
                Button(action: { //This button is for changing the password. There is no "change password" functionality only visuals
                    if (Password == "" ) {
                        showAlert.toggle()
                        alerTitle = "Your did not enter the correct current password"
                    } else if (NewPassword == "") {
                            showAlert.toggle()
                            alerTitle = "Type in your new Password"
                            
                            
                    } else if (ConfirmPassword == "") {
                        showAlert.toggle()
                        alerTitle = "Confirm your Password"
                        
                        
                } else {
                        showAlert.toggle()
                        alerTitle = "Password changed successfully"
                    }
                    
                }, label: {
                    
                        Text("Change Password")
                            .padding()
                            .frame(maxWidth: 250)
                            .foregroundColor(Color.white)
                            .padding(8).background(Color.red.opacity(0.3))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .bold()
                            .cornerRadius(50)
                            .background(
                            RoundedRectangle(cornerRadius: 9)
                                .fill(EverythingIsfilled ? Color.yellow : Color.gray)
                                .frame(width:270, height: 70)
                        )
                })
                .alert(isPresented: $showAlert) { // Creates an Alert
                    Alert(title: Text(alerTitle),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("OK")) {
                        if (alerTitle == "Password changed successfully") {
                            self.presentationMode.wrappedValue.dismiss() // When you press ok on the alert it will go back to the previous page

                        }
                    })
                }
               
                
        }.padding()
        
            Spacer()
      
        
                 
               }
               
            
           }

#Preview {
    ChangePasswordView()
}

