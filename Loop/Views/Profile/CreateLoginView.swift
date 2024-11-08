//
//  SetUpView.swift
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
    @State var ConfirmPassword: String = ""
    @State var ConfirmButton: String = ""
    @State var ProfilePicture: String =  "person.crop.circle"
    @State var HavePicture: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
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
    
    
    var hasAllFields: Bool {
        !Email.isEmpty
        || !Password.isEmpty
        || !Username.isEmpty
        || !Name.isEmpty
        || !ConfirmPassword.isEmpty
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
                            Circle().frame(width: 120, height: 120).foregroundColor(.gray).overlay(
                                Image(systemName: "person.fill").resizable().frame(width: 60, height: 60).foregroundColor(.white)
                            ).frame(alignment:.center)
                            
                            //BLUE EDIT PLUS BUTTON
                            Circle().frame(width: 40, height: 40).foregroundColor(.red).overlay(
                                Image(systemName: "plus").foregroundColor(.white).font(.system(size: 20, weight: .bold))
                            ).offset(x: 40, y: 40).onTapGesture {
                                print("Edit Profile Picture tapped")
                            }
                        }
                        .frame(alignment: .center)
                        .offset(x: 125, y: 10)

                    }

                    
                    
                    VStack (spacing: -10){
                        
                        HStack {
                            TextField("Full Name", text: $Name)
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
                        
                        HStack {
                            TextField("Email Address", text: $Email)
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
                            if isSecure {
                                SecureField("Password", text: $Password)
                                    .padding(.trailing, 32) // Add padding to leave space for the button
                                    .autocapitalization(.none)
                                    .onChange(of: Password, initial: true) {
                                        secondRequirenment = containsNumber(in: Password)
                                        if (Password.count >= 8) {
                                            firstRequirenment = true
                                            
                                        } else {
                                            firstRequirenment = false
                                        }
                                        thirdRequirenment = (containsNoSpecialCharacters(in: Password)) && firstRequirenment
                                    }
                                    .textContentType(.oneTimeCode)
                            } else {
                                TextField("Password", text: $Password)
                                    .padding(.trailing, 32)
                                    .autocapitalization(.none)
                                    .onChange(of: Password, initial: true) {
                                        secondRequirenment = containsNumber(in: Password)
                                        if (Password.count >= 8) {
                                            firstRequirenment = true
                                            
                                        } else {
                                            firstRequirenment = false
                                        }
                                        thirdRequirenment = containsNoSpecialCharacters(in: Password) && firstRequirenment
                                    }
                                    .textContentType(.oneTimeCode)
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
                        
                        
                        
                        
                        HStack {
                            if isSecure2 {
                                SecureField("Confirm Password", text: $ConfirmPassword)
                                    .autocapitalization(.none)
                                    .padding(.trailing, 32) // Add padding to leave space for the button
                                    .textContentType(.oneTimeCode)
                            } else {
                                TextField("Confirm Password", text: $ConfirmPassword)
                                    .autocapitalization(.none)
                                    .padding(.trailing, 32)
                                    .textContentType(.oneTimeCode)
                            }
                            
                            Button(action: {
                                isSecure2.toggle()
                            }) {
                                Image(systemName: isSecure2 ? "eye.slash" : "eye")
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
                    HStack {
                        
                        Image(systemName: firstRequirenment ? "checkmark.circle.fill" : "circle.fill")
                            .foregroundColor(firstRequirenment ? Color.green : Color.gray)
                        Text("At Least 8 Characters")
                                .foregroundColor(firstRequirenment ? Color.black : Color.gray)
                        
                        
                        
                    }
                    .offset(x:20)
                    
                    HStack {
                        
                        Image(systemName:secondRequirenment ? "checkmark.circle.fill" : "circle.fill")
                            .foregroundColor(secondRequirenment ? Color.green : Color.gray)
                        Text("At least 1 number")
                            .foregroundColor(secondRequirenment ? Color.black : Color.gray)

                        
                    }
                    .offset(x:20)
                    
                    
                    
                    
                    HStack {
                        
                        Image(systemName: thirdRequirenment ? "checkmark.circle.fill" : "circle.fill")
                            .foregroundColor(thirdRequirenment ? Color.green : Color.gray)

                        Text("At least 1 Special Characters")
                            .foregroundColor(thirdRequirenment ? Color.black : Color.gray)

                        
                    }
                    .offset(x:20)
                
                }.padding()
                   
                
                
                HStack {
                    Button(action: {
                        TOS.toggle()
                    }) {
                        Image(systemName: TOS ? "checkmark.square.fill" : "square")
                            .foregroundColor(TOS ? .black : .gray)
                    }
                    
                    
                    Text("I agree to our ")
                        .foregroundColor(.gray)
                    + Text("Terms of Service")
                        .foregroundColor(.gray)
                        .underline()
//                        .onTapGesture {
//                            openTermsOfService()
//                        }
                        
                    + Text(" and ")
                        .foregroundColor(.gray)
                    + Text("Privacy Policy")
                        .foregroundColor(.gray)
                        .underline()
//                        .onTapGesture {
//                            openPrivacyPolicy()
//                        }
                        
                }
                .font(.footnote)
                      
                
                
                Button(action: {
                    // Add the "Create Account" function here
                    if (Name == "" ) {
                        showAlert.toggle()
                        alerTitle = "Full Name is Empty"
                    } else if (Username == "") {
                            showAlert.toggle()
                            alerTitle = "Username is Empty "
                            
                            
                    } else if (Email == "") {
                        showAlert.toggle()
                        alerTitle = "Email Address is Empty"
                        
                        
                    } else if (Password == ""){
                        showAlert.toggle()
                        alerTitle = "Your Password is Empty"
                    } else if (ConfirmPassword != Password) {
                        showAlert.toggle()
                        alerTitle = "Comfirm Password is not the same as Password"

                    } else {
                        alerTitle = "Password changed successfully"
                    }
                    signup()
                }, label: {
                    Text("Create Account")
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
                        if (alerTitle == "Account Created Succssfully") {
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
               
               
                
                
                
                
                
                
                HStack {
                    
                    Text("Already Have an Accout?")
                        .foregroundColor(Color.black)
                        .font(.system(size: 15))
                       
            
                    NavigationLink(destination: LoginView()){
                        Text("Sign in")
                          
                            .font(.system(size: 15))
                            .foregroundColor(Color.red)
                            .bold()
                            .cornerRadius(50)
                            .ignoresSafeArea()
                          
                    }
                    
                    
                    .navigationBarBackButtonHidden(true)
               
                }
               
                
            }
            .padding(.top, -90)
            .offset(y:20)
            
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
        let user = User(uid: uid, name: Name, username: Username, challengeIds: [], profilePictureId: profilePicID, friends: [], incomingRequest: [])
        
        if (Password != ConfirmPassword) {
            alertMessage = "Passwords do not match"
            showAlert.toggle()
        }
        
        Task {
            var result = await authManager.signUp(email: Email, password: Password, user: user)
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

func containsNumber(in string: String) -> Bool {
    // Iterate through each character in the string
    for character in string {
        // Check if the character is a digit
        if character.isNumber {
            return true // Return true if at least one digit is found
        }
    }
    return false // Return false if no digits are found
}


func containsNoSpecialCharacters(in string: String) -> Bool {
    // Define a character set that includes letters and digits
    let allowedCharacterSet = CharacterSet.alphanumerics
    // Check if the string is only made up of allowed characters
    return string.rangeOfCharacter(from: allowedCharacterSet.inverted) != nil
}


#Preview {
    CreateLoginView()
        .environmentObject(AuthManager())
}
