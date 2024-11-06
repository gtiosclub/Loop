//
//  GreetingssView.swift
//  Loop
//
//  Created by sw4tpor720 nguyen on 11/5/24.
//

import SwiftUI

struct GreetingssView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            // Welcome text
            Text("Welcome,\nJane")
                .font(.system(size: 55, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.top, 50)
            
            // Profile picture placeholder
            Circle()
                .fill(Color.gray)
                .frame(width: 150, height: 140)
                .padding(.top, 20)
            
            
            
            // Bottom navigation icons
            HStack(spacing: 30) {
                Image(systemName: "house.fill")
                Image(systemName: "target")
                Image(systemName: "stopwatch")
                Image(systemName: "person.fill")
            }
            .foregroundColor(.red)
            .font(.title)
            .padding(.bottom, 40)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
            .offset(y: -40	)
    }
}

#Preview {
    GreetingssView()
}
                        
