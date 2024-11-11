//
//  SelfProfileStatsView.swift
//  Loop
//
//  Created by Seohyun Park on 10/29/24.
//

import SwiftUI

struct SelfProfileStatsView: View {
    let messages = ["This Week", "Total Statistics"]
    
    var body: some View {
        VStack {
            VStack {
                ForEach(messages, id: \.self) { message in
                    VStack(alignment: .leading, spacing: 10) {
                        VStack {
                            HStack {
                                Text(message)
                                
                                Spacer()
                            }
                            Rectangle()
                                .fill(.gray.opacity(0.8))
                                .frame(height: 200)
                            
                        }.padding(8)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    
                    Spacer().frame(height: 15)
                }
            }
        }.padding()
    }
}

#Preview {
    SelfProfileStatsView()
}
