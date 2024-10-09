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
    @Environment(\.presentationMode) var presentationMode
    @State private var isPickerShowing = false
    @State private var selectedImage: UIImage?
    @EnvironmentObject var authManager: AuthManager
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var hasAllFields: Bool {
        !Email.isEmpty
        || !Password.isEmpty
        || !Username.isEmpty
        || !Name.isEmpty
        || !ComfirmPassword.isEmpty
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()

                Button(action: {
                    isPickerShowing.toggle()
                }, label: {
                    if (HavePicture) {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.circle)
                            .frame(width: 200, height: 200)
                    } else {
                        Image(systemName: ProfilePicture)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
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
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
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
                    signup()
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
                .disabled(!hasAllFields)
                
                
                .padding()
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Have an Account?")
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
                
                .navigationBarBackButtonHidden(true)
                Spacer()
            }
        }
        .sheet(isPresented: $isPickerShowing, onDismiss: nil, content: {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
        })
        .onChange(of: selectedImage) { _, newValue in
            if newValue != nil {
                HavePicture = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login Failed"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    func signup() {
        let uid = UUID().uuidString
        var profilePicID = HavePicture ? uid : "None"
        let user = User(uid: uid, name: Name, username: Username, challengeIds: [], profilePictureId: profilePicID, friends: [])
        
        if (Password != ComfirmPassword) {
            alertMessage = "Passwords do not match"
            showAlert.toggle()
        }
        
        Task {
            var result = await authManager.signUp(email: Email, password: Password)
            if (!result) {
                alertMessage = authManager.errorMessage ?? "Unknown error occured"
                showAlert.toggle()
                return
            }
            
            if HavePicture {
                FirebaseUploader.uploadPhoto(image: selectedImage, uid: profilePicID)
            } else {
                print("No profile pic")
            }
            
            var success = await user.addUser()
            
            if success != nil {
                authManager.isAuthenticated = true
            } else {
                alertMessage = "Could not create account"
                showAlert.toggle()
            }
            
        }

    }

}

#Preview {
    CreateLoginView()
        .environmentObject(AuthManager())
}
