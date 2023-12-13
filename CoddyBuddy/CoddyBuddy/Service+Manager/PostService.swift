//  PostService.swift
//  Created by Aum Chauhan on 22/07/23.

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

actor PostService {
    
    public var postListner: ListenerRegistration? = nil
    
    // MARK: - Publish Post
    /// - Publishes Posts (To Post Collection) & Creates Tags Collection.
    func publishPost(textSnippet: String, codeBlock: String,  urlString: String, tags: [String], isPostAnonymous: Bool) async throws {
        guard let userUID = Auth.auth().currentUser?.uid else {
            throw URLError(.userAuthenticationRequired)
        }
        
        // Creates Blank Document With UID
        // POST REQUEST
        let document = FSCollections.posts.document()
        // Post UID
        let postDocID = document.documentID
        
        var postSearchKeywords: [String] = []
        postSearchKeywords.append(contentsOf: ValidationService.stringToArray(textSnippet.lowercased()))
        postSearchKeywords.append(contentsOf: ValidationService.stringToArray(codeBlock.lowercased()))
        postSearchKeywords.append(contentsOf: tags)
        
        // Data Initializing
        let postDataModel = PostModel(
            postOwnerUID: userUID,
            postUID: postDocID,
            postedOnDate: Date(),
            postSearchKeywords: postSearchKeywords,
            // Content
            postContent: PostContentModel(
                textSnippet: textSnippet,
                codeBlock: codeBlock,
                urlString: urlString,
                tags: tags
            ),
            // Analytics
            postAnalytics: PostAnalytics(
                postAnonymously: isPostAnonymous
            )
        )
        
        // PUT REQUEST
        try document.setData(from: postDataModel)
        
        // If Post Is !Anonymous Then Storing PostUID Into UserProfile
        if !isPostAnonymous {
            let collectionReference = FSCollections.userProfile.document(userUID).collection(FSCollections.userPosts)
            
            // Post Count
            let postCount = try await collectionReference.aggregateCount()
            
            let postData = [
                "\(UserModelKeys.userActivities).\(UserActivityKey.postCount)" : postCount
            ]
            // PATCH REQUEST
            try await FSCollections.userProfile.document(userUID).updateData(postData)
            
            // POST REQUEST
            try await collectionReference.document(postDocID).setData([:])
        }
        
        // Creating Tags Collection (From `[tags]`)
        for eachTag in tags {
            if eachTag != "" {
                // POST REQUEST
                try await FSCollections.tags.document(eachTag)
                    .collection(FSCollections.postUIDs).document(postDataModel.postUID).setData([:])
                
                // Appending Posts Count In Tag Doc
                let postCount = try await getPostCount(for: eachTag)
                
                // PATCH REQUEST
                try FSCollections.tags.document(eachTag).setData(
                    from: TagModel(tagName: eachTag, postCount: postCount),
                    merge: false)
            }
        }
    }
    
    // MARK: - Delete Post
    /// - Delete Post And Post Refrences From Firestore
    func deletePost(postUID: String) async throws {
        // Deleting From Post Collection
        // DELETE REQUEST
        try await FSCollections.posts.document(postUID).delete()
        
        guard let userUID = Auth.auth().currentUser?.uid else {
            throw URLError(.userAuthenticationRequired)
        }
        
        // Removing Reference From User Profile
        let collectionReference = FSCollections.userProfile.document(userUID).collection(FSCollections.userPosts)
        
        // Updating Post Count
        let postCount = try await collectionReference.aggregateCount()
        
        let postData = [
            "\(UserModelKeys.userActivities).\(UserActivityKey.postCount)" : postCount
        ]
        // PATCH REQUEST
        try await FSCollections.userProfile.document(userUID).updateData(postData)
        
        // DELETE REQUEST
        try await collectionReference.document(postUID).delete()
    }
    
    // MARK: - Fetch Posts
    /// - Fetch & Filters Posts (From Post Collection And Tag Collection) Without Listner.
    func fetchPosts(user: UserProfileModel? = nil, forTag: String? = nil, lastDocument: DocumentSnapshot?, filter: MyFeedFilters, searchText: String? = nil) async throws -> ([PostModel], DocumentSnapshot?) {
        // Post Collection Query
        var collectionReference = FSCollections.posts
            .order(by: PostModelKeys.postedOnDate, descending: true)
        
        // Filtering Posts
        switch filter {
        case .recents:
            collectionReference = FSCollections.posts.order(by: PostModelKeys.postedOnDate, descending: true)
            
        case .anonymous:
            collectionReference = FSCollections.posts
                .whereField("\(PostModelKeys.postAnalytics).\(PostAnalyticsKeys.postAnonymously)", isEqualTo: true)
            
        case .following:
            let followingUIDs: [Any]? = user?.userActivities.followingsUID
            
            if (followingUIDs?.count ?? 0 >= 1) {
                collectionReference = FSCollections.posts
                    .whereField(PostModelKeys.postOwnerUID, in: followingUIDs ?? ["nil"])
                    .whereField("\(PostModelKeys.postAnalytics).\(PostAnalyticsKeys.postAnonymously)", isEqualTo: false)
            } else {
                throw ValidationError.noFriendsFound
            }
            
        case .search:
            let searchTextArray: [Any] = ValidationService.stringToArray(searchText?.lowercased() ?? "nil")
            
            collectionReference = FSCollections.posts
                .whereField(PostModelKeys.postSearchKeywords, arrayContainsAny: searchTextArray)
            
        case .user:
            collectionReference = FSCollections.posts
                .whereField(PostModelKeys.postOwnerUID, isEqualTo: user?.userUID ?? "nil")
        }
        
        if forTag != nil {
            if let forTag {
                // Tags Collection Query
                collectionReference = FSCollections.posts
                    .whereField("\(PostModelKeys.postContent).\(PostContentKeys.tags)", arrayContains: forTag)
                    .order(by: PostModelKeys.postedOnDate, descending: true)
            }
        }
        
        if let lastDocument {
            // Paginating to `[PostModel]`
            // GET REQUEST
            return try await collectionReference
                .start(afterDocument: lastDocument)
                .limit(to: 6)
                .getDocumentWithLastDocuments(as: PostModel.self)
        }
        else {
            // Initial Fetch Request
            // GET REQUEST
            return try await collectionReference
                .limit(to: 5)
                .getDocumentWithLastDocuments(as: PostModel.self)
        }
    }
    
    // MARK: - Post Listner
    /// - Fetch Single Post (From Post Collection And Tag Collection) Using Listner.
    func attachListnerToPostInteraction(postUID: String, completionHandler: @escaping (_ post: PostModel?) -> ()) {
        // GET REQUEST
        FSCollections.posts.document(postUID)
            .addSnapshotListener { snapShot , error in
                let decodedPost = try? snapShot?.data(as: PostModel.self)
                completionHandler(decodedPost)
            }
    }
    
    // MARK: - Fetch Post Owner Info
    /// - Fetch Post Owner Info (For Displaying On PostCard).
    func getPostOwnersInfo(userUID: String) async throws -> UserProfileModel {
        // GET REQUEST
        return try await FSCollections.userProfile
            .document(userUID)
            .getDocument(as: UserProfileModel.self)
    }
    
    // MARK: - Count Posts
    /// - Fetch Total Number Of Posts (From Tags Collection).
    func getPostCount(for tag: String) async throws -> Int {
        // GET REQUEST
        return try await FSCollections.tags.document(tag)
            .collection(FSCollections.postUIDs).aggregateCount()
    }
    
    // MARK: - Like Post
    /// - Appends PostUID To PostAnalytics & UserActivities.
    func likePost(post: PostModel, userUID: String) async throws {
        // Appending PostUID To (LikedBy Collection)
        let likedByRef = FSCollections.posts.document(post.postUID).collection(FSCollections.likedBy)
        
        // POST REQUEST
        try await likedByRef.document(userUID).setData([:])
        
        // Updating Likes Count on (PostAnalytics Field)
        let likeCount = try await likedByRef.aggregateCount()
        
        let postData: [String: Any] = [
            "\(PostModelKeys.postAnalytics).\(PostAnalyticsKeys.likeCount)" : likeCount
        ]
        
        // PATCH REQUEST
        try await FSCollections.posts.document(post.postUID).updateData(postData)
        
        // Appending PostUID To UserActivities Field
        let data: [String: Any] = [
            "\(UserModelKeys.userActivities).\(UserActivityKey.likedPostsId)" : FieldValue.arrayUnion([post.postUID])
        ]
        
        // PATCH REQUEST
        try await FSCollections.userProfile.document(userUID).updateData(data)
    }
    
    // MARK: - Remove From Like
    /// - Removes PostUID To PostAnalytics & UserActivities.
    func removeFromLike(post: PostModel, userUID: String) async throws {
        // Removing PostUID To (LikedBy Collection)
        let likedByRef = FSCollections.posts.document(post.postUID).collection(FSCollections.likedBy)
        
        // DELETE REQUEST
        try await likedByRef.document(userUID).delete()
        
        let likeCount = try await likedByRef.aggregateCount()
        
        // Updating Likes Count on (PostAnalytics Field)
        let postData: [String: Any] = [
            "postAnalytics.likeCount" : likeCount
        ]
        
        // PATCH REQUEST
        try await FSCollections.posts.document(post.postUID).updateData(postData)
        
        // Removing Post UID To UserActivities Field
        let data: [String: Any] = [
            "\(UserModelKeys.userActivities).\(UserActivityKey.likedPostsId)" : FieldValue.arrayRemove([post.postUID])
        ]
        
        // PATCH REQUEST
        try await FSCollections.userProfile.document(userUID).updateData(data)
    }
    
    // MARK: - Update Post View
    /// - Updates View Counts And Appends UserUID In(ViewedBy Field).
    func updateViews(post: PostModel) async throws {
        guard let userUID = Auth.auth().currentUser?.uid else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let count: [String: Any] = [
            // Updating Count
            "\(PostModelKeys.postAnalytics).\(PostAnalyticsKeys.views)" : post.postAnalytics.views + 1,
            // Appending UserUID
            "\(PostModelKeys.postAnalytics).\(PostAnalyticsKeys.viewedBy)" : FieldValue.arrayUnion([userUID])
        ]
        
        // Checks User Already Viewed Or Not
        if !post.postAnalytics.viewedBy.contains(userUID) {
            // PATCH REQUEST
            try await FSCollections.posts.document(post.postUID).updateData(count)
        }
    }
    
    // MARK: - Report
    /// - Uploads Post Content To Report Collection
    func reportPosts(post: PostModel) async throws {
        guard let userUID = Auth.auth().currentUser?.uid else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let report = ReportPostModel(
            postUID: post.postUID,
            postOwnerUID: post.postOwnerUID,
            postTextSnippet: post.postContent.textSnippet,
            postCodeBlock: post.postContent.codeBlock,
            postTags: post.postContent.tags,
            postsURL: post.postContent.urlString,
            reportedBy: userUID)
        
        // POST REQUEST
        try FSCollections.reports.document().setData(from: report)
    }
}

