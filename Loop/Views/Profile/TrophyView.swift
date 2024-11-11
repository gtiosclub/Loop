//
//  TrophyView.swift
//  Loop
//
//  Created by Seohyun Park on 10/29/24.
//

import SwiftUI

struct TrophyView: View {
    var body: some View {
        VStack {
            VStack {
                ForEach(1...8, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 10) {
                        VStack {
                            HStack {
                                Image("profile")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 120)
                                
                                Spacer().frame(width: 15)
                                
                                VStack(alignment: .leading) {
                                    Text("Trophy \(index)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text("Accomplishment description")
                                    Text("October 10, 2024")
                                        .font(.subheadline)
                                }
                                Spacer()
                            }
                        }.padding(8)
                    }
                    
                    Spacer().frame(height: 15)
                }
            }
        }.padding()
    }
}

#Preview {
    TrophyView()
}
