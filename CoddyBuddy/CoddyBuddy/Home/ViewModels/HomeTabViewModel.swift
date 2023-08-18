//  HomeTabViewModel.swift
//  Created by Aum Chauhan on 22/07/23.

import SwiftUI
import Foundation
import FirebaseFirestore

enum MyFeedFilters: String, CaseIterable {
    case recents = "Recents"
    case anonymous = "Anonymous"
    case following = "Followings"
    case search = "Search"
    case user = "User"
}

@MainActor
class HomeTabViewModel: ObservableObject {
    
    private let postService = PostService()
    var lastSnapDoc: DocumentSnapshot? = nil
    
    @Published var allPosts: [PostModel] = []
    @Published var searchText: String = ""
    @Published var filterType: MyFeedFilters = .recents

    @Published var isLoading: Bool = true

    @Published var errorOccured: Bool = false
    @Published var errorDescription: String = ""
    
    func fetchPosts(filter: MyFeedFilters? = nil, emptyPosts: Bool, user: UserProfileModel?) {
        Task {
            do {
                withAnimation { isLoading = true }
                if emptyPosts {
                    allPosts = []
                    lastSnapDoc = nil
                }
                
                let (posts, lastDoc) = try await postService.fetchPosts(
                    user: user,
                    lastDocument: lastSnapDoc,
                    filter: filter ?? filterType,
                    searchText: searchText)
                
                withAnimation {
                    allPosts.append(contentsOf: posts)
                    lastSnapDoc = lastDoc
                }
                withAnimation { isLoading = false }
            } catch {
                exceptionHandler(error: error)
            }
        }
    }
    
    private func exceptionHandler(error: Error) {
        errorOccured.toggle()
        errorDescription = error.localizedDescription
        print(error.localizedDescription)
        
        HapticManager.error()
    }
}

