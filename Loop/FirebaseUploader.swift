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
        // Create storage reference
        let storageRef = Storage.storage().reference()
        
        //Check if image can turn into data
        let imageData = image!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        //Specify file path and name
        let fileRef = storageRef.child("images/\(UUID().uuidString).jpg")
        
        // Upload that data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            
            //Check for errors
            if error == nil && metadata != nil {
                print("There was an error when uploading.")
            }
        }
    }
}

