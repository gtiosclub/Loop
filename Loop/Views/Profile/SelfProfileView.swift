import SwiftUI
import Firebase
import FirebaseFirestore

struct SelfProfileView: View {
    @StateObject private var viewModel: FeedViewModel
    @State private var name: String = "Jane Doe"
    @State private var username: String = "username"
    @State private var location: String = "Atlanta, GA"
    @State private var createdDate: String = "Oct 2024"
    @State private var following: Int = 30
    @State private var followers: Int = 30
    @State private var selectedTab = 0
    @State private var currentUserUID: String = ""
    @State private var userId: String
    @State private var showingErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var selfUser: User?
    @State private var numFriends: Int = 0
    private let db = Firestore.firestore()
    
    init(userId: String) {
        self.userId = userId
        _viewModel = StateObject(wrappedValue: FeedViewModel(currentUserId: userId))
    }
    
    private func getCurrentUserUID() -> String {
        if let uid = UserDefaults.standard.string(forKey: "currentUserUID") {
            return uid
        } else {
            let uid = UUID().uuidString
            UserDefaults.standard.set(uid, forKey: "currentUserUID")
            return uid
        }
    }

    private func ensureUserDocumentExists() {
        let userRef = db.collection("users").document(currentUserUID)
        userRef.getDocument { snapshot, error in
            if let error = error {
                print("Error checking user document: \(error.localizedDescription)")
                self.errorMessage = "Failed to verify user data."
                self.showingErrorAlert = true
                return
            }

            if snapshot?.exists == false {
                userRef.setData([
                    "name": "Me",
                    "incomingRequests": [],
                    "friends": []
                ]) { error in
                    if let error = error {
                        print("Error creating user document: \(error.localizedDescription)")
                        self.errorMessage = "Failed to initialize your user data."
                        self.showingErrorAlert = true
                    } else {
                        print("User document created successfully.")
                    }
                }
            } else {
                print("User document already exists.")
            }
        }
    }
    
    func getUser(uid: String) async -> User? {
        let docRef = db.collection("users").document(uid)
        do {
            let document = try await docRef.getDocument()
            if document.exists {
                let dataDescription = document.data()
                if let data = dataDescription {
                    let name: String = data["name"] as! String
                    let username: String = data["username"] as! String
                    let challengeIds: [String] = data["challengeIds"] as! [String]
                    let profilePictureId: String = data["profilePictureId"] as! String
                    let friends: [String] = data["friends"] as! [String]
                    let incomingRequest: [String] = data["incomingRequest"] as! [String]
                    return User(uid: uid, name: name, username: username, challengeIds: challengeIds, profilePictureId: profilePictureId, friends: friends, incomingRequest: incomingRequest)
                }
            }
        } catch {
            print("Error getting user from the Firestore Database: \(error).")
        }
        return nil
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer().frame(width: 20)
                if User.shared.profilePictureId.isEmpty || User.shared.profilePictureId == "None" {
                    Circle()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    if let url = URL(string: User.shared.profilePictureId) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFill().frame(width: 70, height: 70).clipShape(.circle)
                        } placeholder: {
                            ZStack {
                                Circle()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(.gray)
                                    .padding()
                                Image(systemName: "person.circle")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                            }
                        }

                    }
                }
                Spacer().frame(width: 10)
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("@"+username)
                    HStack {
                        /*Text(location)
                            .padding(3)
                            .background(Color.red)
                            .foregroundColor(Color.white)
                            .cornerRadius(4)
                        
                        Spacer().frame(width: 18)
                        
                        Text(createdDate)
                            .padding(3)
                            .background(Color.red)
                            .foregroundColor(Color.white)
                            .cornerRadius(4)*/
                    }
                    .font(.subheadline)
                }
                
                Spacer()
                VStack {
                    NavigationLink(destination: SettingsView(user: selfUser ?? User(uid: "uid", name: "Name", username: "Username", challengeIds: [], profilePictureId: "profilePicID", friends: [], incomingRequest: []))) {
                        VStack(spacing: 5) {
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(.black)
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(.black)
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(.black)
                        }
                        .frame(width: 30)
                        .padding(.trailing, 20)
                    }
                }
                .padding(.bottom, 20)
            }
            
            HStack {
                Spacer().frame(width: 20)

                NavigationLink(destination: ManageFriendsView(userId: selfUser?.uid ?? "", friends: selfUser?.friends ?? [])) {
                    VStack(alignment: .leading) {
                        Text("Friends")
                            .font(.subheadline)
                        
                        Text("\(numFriends)")
                            .fontWeight(.bold)
                            .frame(alignment: .center)
                    }
                }.foregroundStyle(.black)
                
                Spacer()
                NavigationLink(destination: AddFriendsView(hasAppeared: false, friends: selfUser?.friends ?? [], userId: userId)){
                    ZStack {
                        Rectangle()
                            .foregroundColor(.red)
                            .frame(width: 35, height: 35)
                            .cornerRadius(10)
                        Image(systemName: "person.badge.plus")
                            .foregroundStyle(.white)
                    }
                }
            }.padding([.leading, .trailing])
            
            VStack {
                Spacer()
                Text("Your Activities")
                    .foregroundColor(selectedTab == 0 ? .black : .gray)
                    .frame(alignment: .top)
                    .fontWeight(.bold)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.friendPosts) { post in
                            WorkoutCardView(
                                post: post,
                                viewModel: viewModel
                            )
                            .padding(.horizontal)
                        }
                        .padding(.top)
                    }
                }
                
                
                Spacer()
            }
            .frame(alignment:.top)
            
        }
        .onAppear {
            self.currentUserUID = getCurrentUserUID()
            ensureUserDocumentExists()
            viewModel.fetchSelfPosts(for: userId)  // Commented out until social features are ready
            Task {
                let user = await getUser(uid: userId)
                self.selfUser = user
                self.name = selfUser?.name ?? ""
                self.username = selfUser?.username ?? ""
                self.numFriends = selfUser?.friends.count ?? 0
            }
        }
        .alert("Error", isPresented: $showingErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

struct SelfProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SelfProfileView(userId: "preview-user-id")
    }
}
