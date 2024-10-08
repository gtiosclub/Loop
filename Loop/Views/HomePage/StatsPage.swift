//
//  StatsPage.swift
//  Loop
//
//  Created by Victor  Andrade on 10/3/24.
//

import SwiftUI

struct StatsView: View {
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Stats Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Stats")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Rocky Balboa - Morning Long Run")
                        .font(.headline)
                    
                    Text("\"Had to stay on top\"")
                        .font(.subheadline)
                        .italic()
                }
                .padding(.bottom, 8)
                
                // Distance Section
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "map")
                            .resizable()
                            .frame(width: 32, height: 32)
                        Text("7.4 miles")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Image("map")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 225, height: 225)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    
                }
                
                // Heart Rate Section
                HStack {
                    Image(systemName: "waveform.path.ecg")
                        .resizable()
                        .frame(width: 32, height: 32)
                    Text("167 bpm")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Image("heart")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 225, height: 225)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                // Calories Section
                HStack {
                    Image(systemName: "bolt")
                        .resizable()
                        .frame(width: 32, height: 32)
                    Text("756 cals")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Image("calories")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 225, height: 225)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                // Time and Pace Section
                HStack {
                    Image(systemName: "clock")
                        .resizable()
                        .frame(width: 32, height: 32)
                    VStack(alignment: .leading) {
                        Text("Total time: 1:01:00")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Pace: 8:16/mi")
                            .font(.title3)
                    }
                    Spacer()
                    Image("pace")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 210, height: 200)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
