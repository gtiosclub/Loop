//
//  FeedView.swift
//  Loop
//
//  Created by Jason Nair on 9/17/24.
//

import SwiftUI
//Finaly this is the view that will comprise the feed. This feedview uses a for each loop for each post view to display in the UI. Please also make the posts scrollable, which can be done using a scrollview.
struct FeedView: View {
    @ObservedObject var viewModel = FeedViewModel()
        
        var body: some View {
            //TODO::
            Text("FILL IN")
        }
}

#Preview {
    FeedView()
}
