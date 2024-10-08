//
//  CreateLoginView.swift
//  Loop
//
//  Created by Dennis Nguyen on 10/8/24.
//



import SwiftUI

struct CreateLoginView: View {
    @State var Email: String = ""
    @State var Password: String = ""
    @State var Username: String = ""
    @State var Name: String = ""
    @State var ComfirmPassword: String = ""
    @State var ComfirmButton: String = ""
    @State var ProfilePicture: String =  "person.crop.circle"
    @State var HavePicture: Bool = false
    
    var body: some View {
        ZStack {
                 
                   VStack {
                      Spacer()
                       
                       
                       
                       Button(action: {
                        //Add the "edit photo" function here
                           
                       }, label: {
                           
                           if (HavePicture) {
                               Image(systemName: "poop")
                               // for now there is no image here so yea idk. If I can replace this image with something I would but basically this is where you add an image if an image is provided
                                              .font(.system(size:200))
                           } else {
                               Image(systemName: ProfilePicture)
                                              .font(.system(size:200))
                           }
                          
                       })
                       
                       
                                
                                     
                       VStack(alignment: .leading) {
                           
                           
                           Text("Create Your Account")
                               .foregroundStyle(.black)
                           
                           
                           
                           
                           TextField("Name",text: $Name)
                               .padding()
                               .foregroundColor(.gray)
                               .cornerRadius(10)
                               .font(.system(size: 15, weight: .regular))
                           
                           TextField("Username",text: $Username)
                               .padding()
                               .foregroundColor(.gray)
                               .cornerRadius(10)
                               .font(.system(size: 15, weight: .regular))
                           
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
                       
                           SecureField("Comfirm Passowrd", text: $ComfirmPassword)
                               .padding()
                               .foregroundColor(.gray)
                               .cornerRadius(10)
                               .font(.system(size: 15, weight: .regular))
                       }
                       .padding(.horizontal)
                       Button(action: {
                          // Add the "Create Account" function here
                           
                       }, label: {
                           Text("Create Account")
                               .padding()
                               .frame(maxWidth: 170)
                               .foregroundColor(Color.black)
                               .bold()
                               .cornerRadius(50)
                           
                               .background(
                                           RoundedRectangle(cornerRadius: 5)
                                               .fill(Color.gray) // Fill the background with gray
                                       )
                       })
                       
                       
                       .padding()
                     
                       
                       
                       
                       Spacer()
                   }
                 
               }
               
            
           }
           
           
}

#Preview {
    CreateLoginView()
}
