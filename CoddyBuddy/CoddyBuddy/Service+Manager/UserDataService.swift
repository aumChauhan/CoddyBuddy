//  UserDataService.swift
//  Created by Aum Chauhan on 22/07/23.

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserDataService {
    /// - Uploads User Details To Firestore (Auth Method: By Email).
    func setUserDataWithEmail(from user: UserProfileModel) async throws {
        // POST REQUEST
        try FSCollections.userProfile.document(user.userUID)
            .setData(from: user, merge: false)
    }
    
    /// - Uplaods User Details To Firestore (Auth Method: With Google).
    func setUserDataWithGoogle(from user: UserProfileModel) async throws {
        // POST REQUEST
        try FSCollections.userProfile.document(user.userUID)
            .setData(from: user, merge: false)
    }
    
    /// - Fetch Current User Data (Without Listners).
    func getUserData(fromUID: String) async throws -> UserProfileModel {
        // GET REQUEST
        return try await FSCollections.userProfile.document(fromUID).getDocument(as: UserProfileModel.self)
    }
    
    /// - Fetch Current User Data (With Listners).
    func getUserData(for UID: String, completionHandler: @escaping (_ userData: UserProfileModel?) -> ()) {
        // GET REQUEST
        FSCollections.userProfile
            .whereField(UserModelKeys.userUID, isEqualTo: UID)
            .snapShotlistner(as: UserProfileModel.self) { (userData, DocumentSnapshot) in
                completionHandler(userData?.first)
            }
    }
    
    /// - Updates Profile Photo URL (From ProfileURL Field).
    func updateUserProfileURL(userUID: String, imageURL: String) async throws {
        let data: [String : Any] = [
            UserModelKeys.profilePicURL : imageURL
        ]
        
        // PATCH REQUEST
        try await FSCollections.userProfile.document(userUID).updateData(data)
    }
    
    /// - Appends ChatRoom Name (In User Activites Field).
    func appendToJoinChatRoomField(userUID: String, chatRoomName: String) async throws {
        let data: [String : Any] = [
            "\(UserModelKeys.userActivities).\(UserActivityKey.joinedChatRooms)" : FieldValue.arrayUnion([chatRoomName])
        ]
        
        // PATCH REQUEST
        try await FSCollections.userProfile.document(userUID).updateData(data)
    }
    
    /// Removes ChatRoom Name (From User Activites Field).
    func removeFromJoinChatRoomsField(userUID: String, chatRoomName: String) async throws {
        let data: [String: Any] = [
            "\(UserModelKeys.userActivities).\(UserActivityKey.joinedChatRooms)" : FieldValue.arrayRemove([chatRoomName])
        ]
        
        // PATCH REQUEST
        try await FSCollections.userProfile.document(userUID).updateData(data)
    }
    
    /// - Checks Username(From Users Profile Collection) Exists Or Not.
    func checkUserNameExists(userName: String) async throws -> Bool {
        // GET REQUEST
        let querySnapshot = try await FSCollections.userProfile
            .whereField(UserModelKeys.userName, isEqualTo: userName)
            .getDocuments()
        
        if querySnapshot.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    /// - Appends UserUIDs TO SignedIn User's Following Collection (And Appending Into Follower Collection)
    func follow(followTo: String) async throws {
        // Current Signed In User Data
        guard let currentUser = Auth.auth().currentUser else { throw URLError(.userAuthenticationRequired) }
        
        // Appends UID To Signed In User Following Collection
        // UserProfile.uid.Following (Collection Refrence)
        let followingCollectionRef = FSCollections.userProfile.document(currentUser.uid).collection(FSCollections.following)
        // POST REQUEST
        try await followingCollectionRef.document(followTo).setData([:])
        
        // Current User Following Count
        let followingCount = try await followingCollectionRef.aggregateCount()
        
        let followingData: [String : Any] = [
            "\(UserModelKeys.userActivities).\(UserActivityKey.followingCount)" : followingCount,
            "\(UserModelKeys.userActivities).\(UserActivityKey.followingsUID)" : FieldValue.arrayUnion([followTo]),
        ]
        
        // PATCH REQUEST
        try await FSCollections.userProfile.document(currentUser.uid).updateData(followingData)
        
        // Appends Current User UID Into Followers Collection Of Following User
        // UserProfile.followTo.Follower (Collection Refrence)
        let followerCollectionRef = FSCollections.userProfile.document(followTo).collection(FSCollections.followers)
        // POST REQUEST
        try await followerCollectionRef.document(currentUser.uid).setData([:])
        
        // FollowTo' User Follower Count
        let followerCount = try await followerCollectionRef.aggregateCount()
        
        let followerData: [String : Any] = [
            "\(UserModelKeys.userActivities).\(UserActivityKey.followerCount)" : followerCount,
            "\(UserModelKeys.userActivities).\(UserActivityKey.followersUID)" : FieldValue.arrayUnion([currentUser.uid]),
        ]
        
        // PATCH REQUEST
        try await FSCollections.userProfile.document(followTo).updateData(followerData)
    }
    
    /// - Removes UserUIDs From SignedIn User's Following Collection (And Appending Into Follower Collection)
    func unFollow(unFollowTo: String) async throws {
        // Current Signed In User Data
        guard let currentUser = Auth.auth().currentUser else { throw URLError(.userAuthenticationRequired) }
        
        // Removes UID From Signed In User Following Collection
        // UserProfile.uid.Following (Collection Refrence)
        let followingCollectionRef = FSCollections.userProfile.document(currentUser.uid).collection(FSCollections.following)
        // POST REQUEST
        try await followingCollectionRef.document(unFollowTo).delete()
        
        // Current User Following Count
        let followingCount = try await followingCollectionRef.aggregateCount()
        
        let followingData: [String : Any] = [
            "\(UserModelKeys.userActivities).\(UserActivityKey.followingCount)" : followingCount,
            "\(UserModelKeys.userActivities).\(UserActivityKey.followingsUID)" : FieldValue.arrayRemove([unFollowTo]),
        ]
        
        // PATCH REQUEST
        try await FSCollections.userProfile.document(currentUser.uid).updateData(followingData)
        
        // Removes Current User UID From Followers Collection Of Following User
        // UserProfile.followTo.Follower (Collection Refrence)
        let followerCollectionRef = FSCollections.userProfile.document(unFollowTo).collection(FSCollections.followers)
        // POST REQUEST
        try await followerCollectionRef.document(currentUser.uid).delete()
        
        // FollowTo' User Follower Count
        let followerCount = try await followerCollectionRef.aggregateCount()
        
        let followerData: [String : Any] = [
            "\(UserModelKeys.userActivities).\(UserActivityKey.followerCount)" : followerCount,
            "\(UserModelKeys.userActivities).\(UserActivityKey.followersUID)" : FieldValue.arrayRemove([currentUser.uid]),
        ]
        
        // PATCH REQUEST
        try await FSCollections.userProfile.document(unFollowTo).updateData(followerData)
    }
    
    /// - Fetch User Information (For Followers, Followings & ChatRoom Members)
    func fetchUsersInfo(_ path: ProfileRefernce, user: UserProfileModel, lastDocument: DocumentSnapshot?) async throws -> ([UserProfileModel], DocumentSnapshot?)  {
        // Default
        var collectionReference = FSCollections.userProfile
            .order(by: PostModelKeys.postedOnDate, descending: true)
        
        switch path {
        case .followers:
            let tempUserUIDs: [Any] = user.userActivities.followersUID
            
            if tempUserUIDs.isEmpty {
                throw ValidationError.noFriendsFound
            } else {
                collectionReference = FSCollections.userProfile
                    .whereField(UserModelKeys.userUID, in: tempUserUIDs)
            }
        case .followings:
            let tempUserUIDs: [Any] = user.userActivities.followingsUID
            
            if tempUserUIDs.isEmpty {
                throw ValidationError.noFriendsFound
            } else {
                collectionReference = FSCollections.userProfile
                    .whereField(UserModelKeys.userUID, in: tempUserUIDs)
            }
        case .viewer:
            break
            
        case .members:
            break
        }
        
        if let lastDocument {
            // Paginating to `[UserProfileModel]`
            // GET REQUEST
            return try await collectionReference
                .start(afterDocument: lastDocument)
                .limit(to: 6)
                .getDocumentWithLastDocuments(as: UserProfileModel.self)
        }
        else {
            // Initial Fetch Request
            // GET REQUEST
            return try await collectionReference
                .limit(to: 5)
                .getDocumentWithLastDocuments(as: UserProfileModel.self)
        }
    }
}

