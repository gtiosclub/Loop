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
    var body: some View {
        ZStack {
            
            VStack {
            
                
                Text("Change Your Email")
                    .foregroundStyle(.black)
                TextField("New Email",text: $NewEmail)
                    .padding()
                    .foregroundColor(.gray)
                    
                    .cornerRadius(10)
                    .font(.system(size: 15, weight: .regular))
                
                
                
                
                SecureField("Comfirm Email", text: $ComfirmEmail)
                    .padding()
                    .foregroundColor(.gray)
                    .cornerRadius(10)
                    .font(.system(size: 15, weight: .regular))
                
                
                
                SecureField("Password", text: $Password)
                    .padding()
                    .foregroundColor(.gray)
                    .cornerRadius(10)
                    .font(.system(size: 15, weight: .regular))
                
                
                   
                Button(action: {
                    
                }
                       
                       
                       , label: {
                    
                   
                   
                        Text("Change Email")
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
    ChangeEmailView()
}

