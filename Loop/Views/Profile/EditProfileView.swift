//
//  EditProfileView.swift
//  Loop
//
//  Created by Jihoon Kim on 10/6/24.
//

import SwiftUI

struct EditProfileView: View {
    @State var Name: String = ""
    @State var Username: String = ""
    @State var Bio: String = ""
    @State private var showConfirmationAlert = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
            VStack(spacing: 10) {
                ZStack{
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left.circle.fill").font(.system(size: 30)).foregroundColor(.red)
                            Spacer()
                        }
                    }
                    Text("Edit Profile").font(.title).bold()
                }
                
                
                
                //PROFILE PICTURE
                ZStack {
                    Circle().frame(width: 120, height: 120).foregroundColor(.gray).overlay(
                            Image(systemName: "person.fill").resizable().frame(width: 60, height: 60).foregroundColor(.white)
                        )

                    //BLUE EDIT PLUS BUTTON
                    Circle().frame(width: 40, height: 40).foregroundColor(.red).overlay(
                            Image(systemName: "plus").foregroundColor(.white).font(.system(size: 20, weight: .bold))
                        ).offset(x: 40, y: 40).onTapGesture {
                            print("Edit Profile Picture tapped")
                        }
                }
            
                //NAME
                VStack(alignment: .leading) {
                    Text("Name").font(.headline)
                    TextField("Enter your name", text: $Name).padding().background(Color(.systemGray6)).cornerRadius(10)
                }

                //USERNAME
                VStack(alignment: .leading) {
                    Text("Username").font(.headline)
                    TextField("Enter your username", text: $Username).padding().background(Color(.systemGray6)).cornerRadius(10)
                }

                //BIO
                VStack(alignment: .leading) {
                    Text("Bio").font(.headline)
                    TextEditor(text: $Bio).frame(height: 100).padding().background(Color(.systemGray6)).cornerRadius(10)
                }

                Spacer()

                //SAVE CHANGES BUTTON
                Button(action: {
                    saveChanges()
                }) {
                    Text("Save Changes")
                        .bold()
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .alert(isPresented: $showConfirmationAlert) {
                    Alert(
                        title: Text("Profile Updated"),
                        message: Text("Your changes have been saved."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }

        private func saveChanges() {
            //implement additional logic here (saving to database or API)
            
            showConfirmationAlert = true
        }
    
}


#Preview {
    EditProfileView()
}
