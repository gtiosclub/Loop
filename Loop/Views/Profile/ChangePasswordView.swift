//
//  ChangePassword.swift
//  Loop
//
//  Created by Dennis nguyen on 10/3/24.
//





import SwiftUI

struct ChangePasswordView: View {
    @State var Email: String = ""
    @State var Password: String = ""
    @State var ComfirmPassword: String = ""
    var body: some View {
        ZStack {
            
            VStack {
            
                
                Text("Change Your Password")
                    .foregroundStyle(.black)
                TextField("Current Password",text: $Email)
                    .padding()
                    .foregroundColor(.gray)
                    .cornerRadius(10)
                    .font(.system(size: 15, weight: .regular))
                
                SecureField("New Password", text: $Password)
                    .padding()
                    .foregroundColor(.gray)
                    .cornerRadius(10)
                    .font(.system(size: 15, weight: .regular))
                
                
                
                
                SecureField("Comfirm New Password", text: $ComfirmPassword)
                    .padding()
                    .foregroundColor(.gray)
                    .cornerRadius(10)
                    .font(.system(size: 15, weight: .regular))
                
                   
                Button(action: {
                    
                    
                }, label: {
                    Text("Change Password")
                        .padding()
                        .frame(maxWidth: 250)
                        .foregroundColor(Color.black)
                    
                        .bold()
                        .cornerRadius(50)
                        .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.gray) // Fill the background with gray
                                )
                })
                
            }
        }
                 
               }
               
            
           }

#Preview {
    ChangePasswordView()
}

