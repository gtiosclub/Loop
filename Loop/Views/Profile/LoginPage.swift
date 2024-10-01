//
//  LoginPage.swift
//  Loop
//
//  Created by sw4tpor720 nguyen on 10/1/24.
//


import SwiftUI

struct LoginView: View {
    @State var Email: String = "Enter Email Here"
    @State var Password: String = "Enter Password Here"
    
    var body: some View {
        ZStack {
                 
                   VStack {
                       Spacer()
                       
                       
                       VStack(alignment: .leading) {
                           
                           Text("Log into your account")
                               .foregroundStyle(.black)
                           TextField("Email",text: $Email)
                               .padding()
                               .foregroundColor(.gray)
                               .cornerRadius(10)
                               .font(.system(size: 15, weight: .regular))
                           
                           SecureField("Password", text: $Password)
                               .padding()
                               .foregroundColor(.gray)
                               .cornerRadius(10)
                               .font(.system(size: 15, weight: .regular))
                       }
                       .padding(.horizontal)
                       Button(action: {
                          
                           
                       }, label: {
                           Text("Login")
                               .padding()
                               .frame(maxWidth: 170)
                               .foregroundColor(Color.black)
                               
                               .bold()
                               .cornerRadius(50)
                       })
                       
                       .padding()
                     
                       Button(action: {
                           
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
                               .bold()
                           Button {
                             
                               
                           } label: {
                               Text("Sign Up")
                                   .foregroundColor(Color.black)
                                   .font(.system(size: 15))
                                   .bold()
                           }
                       }
                       
                       Spacer()
                   }
                 
               }
               
            
           }
           
           
}

#Preview {
    LoginView()
}
