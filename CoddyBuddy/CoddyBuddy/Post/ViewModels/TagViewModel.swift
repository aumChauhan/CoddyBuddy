//  TagViewModel.swift
//  Created by Aum Chauhan on 22/07/23.

import SwiftUI
import Foundation
import FirebaseFirestore

@MainActor
class TagsViewModel: ObservableObject {
    
    private let postService = PostService()
    var lastSnapDoc: DocumentSnapshot? = nil
    
    @Published var allPostsWithTags: [PostModel] = []
    @Published var postCount: Int = 0
    
    @Published var errorOccured: Bool = false
    @Published var errorDescription: String = ""
    
    func fetchPosts(tag: String) async {
        do {
            let (newPosts, lastDoc) = try await postService.fetchPosts(forTag: tag, lastDocument: lastSnapDoc, filter: .recents)
            
            withAnimation {
                allPostsWithTags.append(contentsOf: newPosts)
                lastSnapDoc = lastDoc
            }
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func getPostCountForTags(tag: String) async {
        do {
            let tempCount = try await postService.getPostCount(for: tag)
            withAnimation {
                postCount = tempCount
            }
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    private func exceptionHandler(error: Error) {
        errorOccured.toggle()
        errorDescription = error.localizedDescription
        
        HapticManager.error()
    }
}
