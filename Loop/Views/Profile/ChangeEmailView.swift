//
//  ChangeEmail.swift
//  Loop
//
//  Created by Dennis nguyen on 10/3/24.
//




import SwiftUI

struct ChangeEmailView: View {
    @State var NewEmail: String = ""
    @State var Password: String = ""
    @State var ComfirmEmail: String = ""
    @State var showAlert: Bool = false
    @State var alerTitle: String = ""
    @State var alertMessage: String = ""
    @State var NewEmailFilled :Bool = false
    @State var ComfirmEmailFilled :Bool = false
    @State var PasswordFilled :Bool = false
    @State var EverythingIsfilled: Bool = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss() // go back to the previous page
        }) {
            Image(systemName: "arrow.left.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(.red)
        }
        .offset(x: -150)
        .navigationBarBackButtonHidden(true)


        

        VStack {
            
            Text("Change Your Email")
                    .foregroundStyle(.black)
                TextField("New Email",text: $NewEmail)
                    .autocapitalization(.none)
                    .padding(8).background(Color.red.opacity(0.3))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onChange(of: NewEmail, initial: true) {
                        if (NewEmail == "") {
                            NewEmailFilled = false
                        } else {
                            NewEmailFilled = true
                        }
                        if (PasswordFilled && NewEmailFilled && ComfirmEmailFilled) {
                            EverythingIsfilled = true
                        } else {
                            EverythingIsfilled = false
                        }
                        print(NewEmail)
                    }
                   
                
                
                TextField("Comfirm Email", text: $ComfirmEmail)
                    .autocapitalization(.none)
                    .padding(8).background(Color.red.opacity(0.3))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onChange(of: ComfirmEmail, initial: true) {
                        if (ComfirmEmail == "") {
                            ComfirmEmailFilled = false
                        } else {
                            ComfirmEmailFilled = true
                        }
                        if (PasswordFilled && NewEmailFilled && ComfirmEmailFilled) {
                            EverythingIsfilled = true
                        } else {
                            EverythingIsfilled = false
                        }
                        print(ComfirmEmail)
                    }
                
                
                SecureField("Password", text: $Password)
                    .autocapitalization(.none)
                    .padding(8).background(Color.red.opacity(0.3))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onChange(of: Password, initial: true) {
                        if (Password == "") {
                            PasswordFilled = false
                        } else {
                            PasswordFilled = true
                        }
                        if (PasswordFilled && NewEmailFilled && ComfirmEmailFilled) {
                            EverythingIsfilled = true
                        } else {
                            EverythingIsfilled = false
                        }
                        print(Password)
                    }
                
                
                   
                Button(action: { //Button to change email but no change functionality only visuals or frontend
                    if (NewEmail == "" ) {
                        showAlert.toggle()
                        alerTitle = "Type in your New Email"
                    } else if (ComfirmEmail == "") {
                            showAlert.toggle()
                            alerTitle = "Comfirm Your New Email"
                            
                            
                    } else if (Password == "") {
                        showAlert.toggle()
                        alerTitle = "Your did not enter the correct current password"
                        
                        
                } else {
                        showAlert.toggle()
                        alerTitle = "Email changed successfully"
                    }
                    
                }
                       
                       
                       , label: {
                    
                   
                   
                        Text("Change Email")
                            .padding()
                            .frame(maxWidth: 250)
                            .foregroundColor(Color.black)
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
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alerTitle),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("OK")) {
                        if (alerTitle == "Email changed successfully") {
                            self.presentationMode.wrappedValue.dismiss()// Brings back the settings page when user presses ok

                        }
                    })
                    
                        
                }
               
                
        }.padding()
        
            Spacer()
      
        
                 
               }
    
               
            
           }

#Preview {
    ChangeEmailView()
}

