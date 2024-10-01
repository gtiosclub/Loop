//
//  FriendProfileView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct FriendProfileView: View {
    @State private var wins: Int = 0
    @State private var lastActivity: String = "No recent activity"

    var body: some View {
        VStack(spacing: 30) {

            HStack {
                Text("Friend Profile")
                    .font(.largeTitle.bold())
                    .foregroundColor(.black)
                    .padding(.leading, 20)
                
                Spacer()

                Button(action: {
                }) {
                    Text("Remove Friend")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(LinearGradient(
                            gradient: Gradient(colors: [.red, .orange]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .padding(.trailing, 20)
            }
            .padding(.top, 60)


            ZStack {
                Circle()
                    .fill(statusColor(for: wins))
                    .frame(width: 170, height: 170)
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding()
                
                VStack {
                    Text("Wins: \(wins)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.orange)
                        .cornerRadius(10)
                        .offset(y: 60)
                }
            }
            
            Text("Last Activity: \(lastActivity)")
                .font(.headline)
                .foregroundColor(.black)
                .padding(10)
                .background(LinearGradient(
                    gradient: Gradient(colors: [.orange.opacity(0.7), .yellow.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .cornerRadius(10)
                .shadow(radius: 3)
                .padding(.top, 20)

            
            VStack(alignment: .leading, spacing: 20) {
               
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.blue)
                        .frame(width: 25, height: 25)
                    
                    VStack(alignment: .leading) {
                        Text("Name")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("insert name")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                    }
                }
                
                
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.green)
                        .frame(width: 25, height: 25)
                    
                    VStack(alignment: .leading) {
                        Text("Location")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("insert location")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                    }
                }
                
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .frame(width: 25, height: 25)
                    
                    VStack(alignment: .leading) {
                        Text("Favorite Activity")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("insert activity")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(20)
            .background(Color.gray.opacity(0.1)) // Slight contrast for info card
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding(.horizontal, 20)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func statusColor(for wins: Int) -> Color {
        switch wins {
        case 0..<100:
            return Color.brown
        case 100..<200:
            return Color.gray
        case 200...:
            return Color.yellow
        default:
            return Color.clear
        }
    }
    
    private func updateLastActivity() {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        lastActivity = "Last interacted on \(formatter.string(from: currentDate))"
    }
}

#Preview {
    FriendProfileView()
}
