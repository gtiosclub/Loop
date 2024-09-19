//
//  FeedViewModel.swift
//  Loop
//
//  Created by Jason Nair on 9/19/24.
//

import Foundation
class FeedViewModel: ObservableObject{
    @Published var posts: [Post] = []
    
    //the init should call a function called loadPosts that will contain an array of mock data Posts
    init(){
        //TODO
    }
    //fill in this function, an array posts of Post()
    func loadPosts() {
        //TODO
    }
}
