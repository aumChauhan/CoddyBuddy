//  TrendingService.swift
//  Created by Aum Chauhan on 31/07/23.

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

actor ExploreService {
    
    /// - Fetch (7) Most Popular Posts (From Post Collection, For Explore Tab).
    func fetchPopularPosts() async throws -> [PostModel]  {
        // GET REQUEST
        try await FSCollections.posts
            .order(by: "\(PostModelKeys.postAnalytics).\(PostAnalyticsKeys.likeCount)", descending: true)
            .limit(to: 7)
            .getDocuments(as: PostModel.self)
    }
    
    /// - Fetch (15) Most Popular Tags (From Tags Collection, For Explore Tab).
    func fetchPopularTags() async throws -> [TagModel] {
        // GET REQUEST
        return try await FSCollections.tags
            .order(by: "\(TagKeys.postCount)", descending: true)
            .limit(to: 15)
            .getDocuments(as: TagModel.self)
    }
    
    /// - Fetch User Profiles From Given Search Text (From User Profile Collection, For Explore Tab).
    func findUsers(text: String) async throws -> [UserProfileModel]  {
        
        // GET REQUEST
        return try await FSCollections.userProfile
            .whereField("\(UserModelKeys.fullName)", isEqualTo: text)
            .getDocuments(as: UserProfileModel.self)
    }
    
    /// - Fetch (7) Most Popular ChatRooms (From ChatRoom Collection, For Explore Tab).
    func fetchPopularChatRooms() async throws -> [ChatRoomModel] {
        // GET REQUEST
        return try await FSCollections.chatRooms
            .whereField(ChatRoomModelKeys.memberCount, isGreaterThanOrEqualTo: 1)
            .limit(to: 7)
            .getDocuments(as: ChatRoomModel.self)
    }
}
