# Loop
Fall 2024 iOS Club Project

Tasks:
- Firebase
  - Sign up/Log in
    - Make basic user model in Swift
      - Store UID and name
      - Store list of challenges (ids)
    - Create User in FirebaseAuth
    - Use UID to create User in Firestore
  - Save profile picture
    - Link UID from a user to photo in Firebase Storage
  - Start on Friend requests
    - Make function to fetch list of users (uids) from Firestore
    - Add incoming requests to user model (list of uids)
    - Add friends to user model (list of uids)
    - Add functionality to send/accept a request
  - Create challenges
    - Make basic challenge model in Swift (doesn't have to be feature complete)
      - Challenge id
      - Challenge name
      - Challenge type
      - Challenge start/end date
      - List of participants (uids)
    - Make function to add challenges to firestore
    - Make function to add user uid to challenge
    - Make function to add challenge id to user
- Persist account accross sign ins (Don't have to log in every time app is opened)
  - Save UID on device
