//
//  ContentView.swift
//  Loop
//
//  Created by Max Ko on 9/13/24.
//

import SwiftUI
import FirebaseStorage

struct ContentView: View {
    @State private var isPickerShowing = false
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            } else {
                Text("No image selected")
            }
            
            Button {
                isPickerShowing = true
            } label: {
                Text("Select a photo")
            }
            
            //upload photo
            if selectedImage != nil {
                Button {
                    FirebaseUploader.uploadPhoto(image: selectedImage)
                } label: {
                    Text("Upload photo")
                }
            }
        }
        .sheet(isPresented: $isPickerShowing, onDismiss: nil, content: {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
        })
    }
    
}

#Preview {
    ContentView()
}
