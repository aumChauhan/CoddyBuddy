//  CollectionManager.swift
//  Created by Aum Chauhan on 02/08/23.

import Foundation
import FirebaseFirestore

/// - Holds FireStores Collections Refrences
class FSCollections {
    
    private init() {}
    
    // MARK: - UserProfile
    /// - Stores User InfoFormation.
    /// ```
    /// Firestore.firestore().collection("UserProfiles")
    /// ```
    static let userProfile = Firestore.firestore().collection("UserProfiles")
    
    // - Stores User UIDs In (Followers & Following In Sub Collections).
    static let followers = "Followers"
    static let following = "Following"
    
    /// - Stores Post UIDs
    /// ```
    /// Firestore.firestore().collection("UserProfiles").document(#).collection("Posts")
    /// ```
    static let userPosts = "Posts"
    
    /// - Stores User Replies UIDs
    /// ```
    /// Firestore.firestore().collection("UserProfiles").document(#).collection("Replies")
    /// ```
    static let userReplies = "Replies"
    
    // MARK: - Posts
    /// - Stores Posts (Replies & LikedBy In Sub Collections).
    /// ```
    /// Firestore.firestore().collection("Posts")
    /// ```
    static let posts = Firestore.firestore().collection("Posts")
    
    /// - Stores Replies In Sub Collection Of Posts Document.
    /// ```
    /// Firestore.firestore().collection("Posts").document(#).collection("Replies")
    /// ```
    static let replies = "Replies"
    
    /// - Stores UserUIDs As A Document Name In Sub Collection Of Posts Document.
    /// ```
    /// Firestore.firestore().collection("Posts").document(#).collection("LikedBy")
    /// ```
    static let likedBy = "LikedBy"
    
    // MARK: - Tags
    /// - Stores Tags Used In Posts & (PostUIDS In Sub Collections).
    /// ```
    /// Firestore.firestore().collection("Tags")
    /// ```
    static let tags = Firestore.firestore().collection("Tags")
    
    /// - Stores UserUIDs As A Document Name In Sub Collection Of Tags Document.
    /// ```
    /// Firestore.firestore().collection("Tags").document(#).collection("PostUID")
    /// ```
    static let postUIDs = "PostUID"
    
    // MARK: - ChatRooms
    /// - Stores ChatRoom Names & (Joined Members & Messages In Sub Collections).
    /// ```
    /// Firestore.firestore().collection("ChatRooms")
    /// ```
    static let chatRooms = Firestore.firestore().collection("ChatRooms")
    
    /// - Stores UserUIDs As A Document Name In Sub Collection Of ChatRooms Document.
    /// ```
    /// Firestore.firestore().collection("ChatRooms").document(#).collection("JoinedMembers")
    /// ```
    static let joinedMembers = "JoinedMembers"
    
    /// - Stores Message In Sub Collection Of ChatRooms Document.
    /// ```
    /// Firestore.firestore().collection("ChatRooms").document(#).collection("Messages")
    /// ```
    static let messages = "Messages"
    
    // MARK: - Reports
    /// - Stores Reported Post's And Users
    /// ```
    /// Firestore.firestore().collection("Reports")
    /// ```
    static let reports = Firestore.firestore().collection("Reports")
    
}
