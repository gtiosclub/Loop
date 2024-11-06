//
//  WelcomView.swift
//  Loop
//
//  Created by Dennis nguyen on 11/5/24.
//

import SwiftUI

struct WelcomView: View {
    var body: some View {
           VStack {
               Spacer()
               
               // Title Text
               Text("Welcome")
                   .font(.system(size: 50))
                   .fontWeight(.bold)
                   .foregroundColor(.white)
                   
               
               Text("to")
                   .font(.largeTitle)
                   .fontWeight(.bold)
                   .foregroundColor(.white)
               Text("Loop")
                   .font(.system(size: 50))
                   .fontWeight(.bold)
                   .foregroundColor(.white)
               
               // Icon (replace with your own image or custom shape)
               Image(systemName: "infinity.circle.fill")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(width: 150, height: 150)
                   .foregroundColor(.white)
                   .padding(.bottom, 50)
               
               Spacer()
               
               // "Get Started" Button
               NavigationLink( destination: CreateLoginView()){
                   Text("Get Started")
                       .font(.headline)
                       .foregroundColor(.white)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.white.opacity(0.2))
                       .cornerRadius(10)
                       .padding(.horizontal, 40)
               }
               .padding(.bottom, 10)
               
               // "Log In" Button
               NavigationLink(destination: LoginView()) {
                   Text("Log In")
                       .font(.headline)
                       .foregroundColor(.white)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.white.opacity(0.2))
                       .cornerRadius(10)
                       .padding(.horizontal, 40)
               }
               .padding(.bottom, 40)
           }
           .background(Color.red.ignoresSafeArea()) // Background color
       }
}


#Preview {
    WelcomView()
}
