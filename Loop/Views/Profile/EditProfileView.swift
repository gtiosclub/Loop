//
//  EditProfileView.swift
//  Loop
//
//  Created by Jihoon Kim on 10/6/24.
//

import SwiftUI
/*
struct EditProfileView: View {
    @State var Name: String = ""
    @State var Username: String = ""
    @State var Bio: String = ""
    @State private var showConfirmationAlert = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isPickerShowing = false
    @State private var selectedImage: UIImage?
    @State var HavePicture: Bool = false
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
                HStack {
                    ZStack {
                        Button(action: {
                            isPickerShowing.toggle()
                        }, label: {
                            if (HavePicture) {
                                Image(uiImage: selectedImage!)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(.circle)
                                    .frame(width: 100, height: 100)
                            } else {
                                ZStack {
                                    Circle().frame(width: 110, height: 110).foregroundColor(.gray).overlay(
                                    Image(systemName: "person.fill").resizable().frame(width: 70, height: 70).foregroundColor(.white)).frame(alignment:.center)
                                    Circle().frame(width: 40, height: 40).foregroundColor(.red).overlay(
                                    Image(systemName: "plus").foregroundColor(.white).font(.system(size: 20, weight: .bold))).offset(x: 40, y: 40)
                                }
                                .frame(alignment: .center)
                            }
                        })
                    }
                    .frame(alignment: .center)
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
            .sheet(isPresented: $isPickerShowing, onDismiss: nil, content: {
                ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
            })
            .onChange(of: selectedImage) { _, newValue in
                if newValue != nil {
                    HavePicture = true
                }
            }
        }
    

        private func saveChanges() {
            //implement additional logic here (saving to database or API)
            
            showConfirmationAlert = true
        }
    
}
*/



import SwiftUI

struct EditProfileView: View {
    @State var Username: String = ""
    @State var Name: String = ""
    @State var ConfirmButton: String = ""
    @State var ProfilePicture: String =  "person.crop.circle"
    @State var HavePicture: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State var user: User
    @State private var isPickerShowing = false
    @State private var selectedImage: UIImage?
    @EnvironmentObject var authManager: AuthManager
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isSecure: Bool = true
    @State private var isSecure2: Bool = true
    @State private var firstRequirenment: Bool = false
    @State private var secondRequirenment: Bool = false
    @State private var thirdRequirenment: Bool = false
    @State private var alerTitle: String = ""
    @State private var TOS: Bool = false
    @State private var InvalidEmail: Bool = false
    
    
    var hasAllFields: Bool {
        !Username.isEmpty && !Name.isEmpty
    }
    
    func checkConditions() {
        if (Name == "" ) {
            showAlert.toggle()
            alerTitle = "Full Name is Empty"
        } else if (Username == "") {
                showAlert.toggle()
                alerTitle = "Username is Empty "
        } else {
            showAlert.toggle()
            alerTitle = "Account edited successfully"
            edit()
        }
    }
    
    var body: some View {
        ZStack (alignment: .top){
            VStack {
                VStack(alignment: .leading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        ZStack {
                            Button(action: {
                                isPickerShowing.toggle()
                            }, label: {
                                if (HavePicture) {
                                    Image(uiImage: selectedImage!)
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(.circle)
                                        .frame(width: 100, height: 100)
                                } else {
                                    ZStack {
                                        Circle().frame(width: 110, height: 110).foregroundColor(.gray).overlay(
                                        Image(systemName: "person.fill").resizable().frame(width: 70, height: 70).foregroundColor(.white)).frame(alignment:.center)
                                        Circle().frame(width: 40, height: 40).foregroundColor(.red).overlay(
                                        Image(systemName: "plus").foregroundColor(.white).font(.system(size: 20, weight: .bold))).offset(x: 40, y: 40)
                                    }
                                    .frame(alignment: .center)
                                }
                            })
                        }
                        .frame(alignment: .center)
                        .offset(x: 125, y: 10)
                    }

                    VStack (spacing: -10){
                        HStack {
                            TextField("Name", text: $Name)
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
                            TextField("Username", text: $Username)
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
                    }
                }.padding()

                Button(action: {
                    // Add the "Create Account" function here
                    checkConditions()
                }, label: {
                    Text("Confirm Changes")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                
                })
                .disabled(!hasAllFields)
                .padding(.vertical, 8)
                
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alerTitle),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("OK")) {
                        if (alerTitle == "Account Edited Succssfully") {
                            self.presentationMode.wrappedValue.dismiss()// Brings back the settings page when user presses ok

                        }
                    })
                    
                        
                }
                
                HStack {
                    Rectangle()
                        .frame(height: 1.5) // Adjust thickness here
                        .foregroundColor(.gray) // Adjust color here
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)
            }
            .padding(.top, -90)
            .offset(y:20)
            
        }
        .fullScreenCover(isPresented: $isPickerShowing) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
        }
        .onChange(of: selectedImage) { _, newValue in
            if newValue != nil {
                HavePicture = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alerTitle),
                  dismissButton: .default(Text("OK")))
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func dismiss() -> Void {
        isPickerShowing = false
    }
    
    func edit() {
        let uid = UUID().uuidString
        let profilePicID = HavePicture ? uid : "None"
        user.name = Name
        user.username = Username
        
        Task {
            if HavePicture {
                FirebaseUploader.uploadPhoto(image: selectedImage, uid: profilePicID) { url in
                    if let url {
                        user.profilePictureId = url.absoluteString
                        User.updatedSharedProfilePic(picURL: user.profilePictureId)
                        print("PROFILE PICTURE URL: \(user.profilePictureId)")
                    } else {
                        print("NO IMAGE UPLOADED")
                    }
                }
            }
            
            let success = await user.updateUser()
            
            
        }

    }

}


private func isValidEmail(_ email: String) -> Bool {
        // Check if the email contains "@" and ends with ".com"
        return email.contains("@") && email.hasSuffix(".com")
    }




#Preview {
    //EditProfileView(userId: "")
}
