//
//  FirebaseUploader.swift
//  Loop
//
//  Created by Shrey Agarwal on 9/26/24.
//

import Firebase
import FirebaseStorage
import UIKit

class FirebaseUploader {
    
    static func uploadPhoto(image: UIImage?) {
        let storageRef = Storage.storage().reference()
        
        let imageData = image!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        let fileRef = storageRef.child("images/\(UUID().uuidString).jpg")
        
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            
            if error == nil && metadata != nil {
                print("There was an error when uploading.")
            }
        }
    }
}

