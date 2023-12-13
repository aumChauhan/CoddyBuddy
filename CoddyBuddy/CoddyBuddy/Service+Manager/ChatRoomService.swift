//  ChatRoomService.swift
//  Created by Aum Chauhan on 22/07/23.

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

actor ChatRoomService {
    
    /// - Creates ChatRoom Document.
    func createChatRoom(chatRoom: ChatRoomModel) async throws {
        // POST REQUEST
        try FSCollections.chatRooms
            .document(chatRoom.chatRoomName).setData(from: chatRoom, merge: false)
    }
    
    /// - Fetch All ChatRooms & User Joined ChatRooms.
    func fetchChatRooms(userUID: String, filter: ChatRoomFilters, searchText: String, lastDocument: DocumentSnapshot?) async throws -> ([ChatRoomModel], DocumentSnapshot?) {
        // Post Collection Query
        var collectionReference = FSCollections.chatRooms.order(by: ChatRoomModelKeys.chatRoomName, descending: false)
        
        // Filtering ChatRooms
        switch filter {
        case .joined:
            collectionReference = FSCollections.chatRooms
                .whereField(ChatRoomModelKeys.membersUID, arrayContains: userUID)
            
        case .explore:
            collectionReference = FSCollections.chatRooms
                .order(by: ChatRoomModelKeys.chatRoomName, descending: false)
            
        case .search:
            collectionReference = FSCollections.chatRooms
                .whereField(ChatRoomModelKeys.chatRoomName, isEqualTo: searchText)
        }
        
        if let lastDocument {
            // Paginating To `[ChatRoomModel]`
            // GET REQUEST
            return try await collectionReference
                .start(afterDocument: lastDocument)
                .limit(to: 6)
                .getDocumentWithLastDocuments(as: ChatRoomModel.self)
        }
        else {
            // Initial Fetch Request
            // GET REQUEST
            return try await collectionReference
                .limit(to: 5)
                .getDocumentWithLastDocuments(as: ChatRoomModel.self)
        }
    }
    
    /// - Uploads ProfilePic URL To ChatRoom Document.
    /// - Note: ChatRoom Profile Photo Feature Is Disabled.
    func updateChatRoomProfileURL(chatRoom: String, imageURL: String) async throws {
        let data: [String : Any] = [
            ChatRoomModelKeys.chatRoomProfileURLString : imageURL
        ]
        // PATCH REQUEST
        try await FSCollections.chatRooms.document(chatRoom).updateData(data)
    }
    
    /// - Appends ChatRoom (Into User Activity & Joined Member Collection).
    func joinChatRoom(userUID: String, chatRoomName: String) async throws {
        // Appending UserUID Into Joined Members Collection.
        // POST REQUEST
        try await FSCollections.chatRooms.document(chatRoomName).collection(FSCollections.joinedMembers).document(userUID).setData([:])
        
        // Appending UserUID Into MembersUID Field
        let membersUIDData: [String : Any] = [
            ChatRoomModelKeys.membersUID : FieldValue.arrayUnion([userUID])
        ]
        
        // PATCH REQUEST
        try await FSCollections.chatRooms.document(chatRoomName).updateData(membersUIDData)
        
        // Upating Member Count
        let memberCount = try await getMembersCount(for: chatRoomName)
        
        let data: [String : Any] = [
            ChatRoomModelKeys.memberCount : memberCount
        ]
        
        // PATCH REQUEST
        try await FSCollections.chatRooms.document(chatRoomName).updateData(data)
    }
    
    /// - Removes ChatRoom Name (From User Activity & Joined Member Collection).
    func leaveChatRoom(userUID: String, chatRoomName: String) async throws {
        // Removing UserUID From Joined Members Collection
        // DELETE REQUEST
        try await FSCollections.chatRooms.document(chatRoomName).collection(FSCollections.joinedMembers).document(userUID).delete()
        
        // Removing UserUID From MembersUID Field
        let membersUIDData: [String : Any] = [
            ChatRoomModelKeys.membersUID : FieldValue.arrayRemove([userUID])
        ]
        
        // DELETE REQUEST
        try await FSCollections.chatRooms.document(chatRoomName).updateData(membersUIDData)
        
        // Upating Member Count
        let memberCount = try await getMembersCount(for: chatRoomName)
        
        let data: [String : Any] = [
            ChatRoomModelKeys.memberCount : memberCount
        ]
        
        // PATCH REQUEST
        try await FSCollections.chatRooms.document(chatRoomName).updateData(data)
    }
    
    /// - Returns Member Count From JoinedMebers Collection.
    func getMembersCount(for chatRoom: String) async throws -> Int {
        // GET REQUEST
        return try await FSCollections.chatRooms.document(chatRoom).collection(FSCollections.joinedMembers).aggregateCount()
    }
    
    /// - Returns Member Count From JoinedMebers Collection.
    func getMessageCount(for chatRoom: String) async throws -> Int {
        // GET REQUEST
        return try await FSCollections.chatRooms.document(chatRoom).collection(FSCollections.messages).aggregateCount()
    }
    
    /// - Fetch Single ChatRoom's Information.
    func fetchChatRoomInfo(chatRoomName: String) async throws -> ChatRoomModel {
        // GET REQUEST
        return try await FSCollections.chatRooms.document(chatRoomName).getDocument(as: ChatRoomModel.self)
    }
    
    
    /// - Fetch UserInfo (From Channel Created By Field).
    func getChatRoomOwnersInfo(userUID: String) async throws -> UserProfileModel {
        // GET REQUEST
        return try await FSCollections.userProfile.document(userUID)
            .getDocument(as: UserProfileModel.self)
    }
    
    /// - Posts Messages (Into Message Collection).
    func postMessageToChatRoom(chatRoomName: String, textSnippet: String, codeBlock: String, urlString: String) async throws {
        guard let userUID = Auth.auth().currentUser?.uid else {
            throw URLError(.userCancelledAuthentication)
        }
        
        // Creating A Blank Document With UID
        let document = FSCollections.chatRooms.document(chatRoomName).collection(FSCollections.messages).document()
        // Initalizing Doc Id To `senderUID` Field
        let messageDocId = document.documentID
        
        let messageContent = ChatRoomMessagesModel(
            id: messageDocId,
            senderUID: userUID,
            sentAt: Date(),
            messageUID: messageDocId,
            textSinppet: textSnippet,
            codeBlock: codeBlock,
            url: urlString
        )
        
        // POST REQUEST
        try document.setData(from: messageContent)
    }
    
    /// Listens Initial 10 Messages (From Message Collection).
    func fetchMessageInitialRequest(chatRoom: String, completionHandler: @escaping (([ChatRoomMessagesModel]?, DocumentSnapshot?)) -> ()) {
        FSCollections.chatRooms.document(chatRoom).collection(FSCollections.messages)
            .order(by: ChatRoomMessageModelKey.sentAt, descending: true)
            .limit(to: 10)
            // GET REQUEST
            .snapShotlistner(as: ChatRoomMessagesModel.self) { (chatRoomMessages, docSnap) in
                completionHandler((chatRoomMessages, docSnap))
            }
    }
    
    /// Appending More 10 Messages (From Message Collection).
    func appendMessages(chatRoom: String, lastDocument: DocumentSnapshot?) async throws -> ([ChatRoomMessagesModel]?, DocumentSnapshot?) {
        guard let lastDocument = lastDocument else {
            throw URLError(.badServerResponse)
        }
        
        return try await FSCollections.chatRooms.document(chatRoom).collection("Messages")
            .order(by: ChatRoomMessageModelKey.sentAt, descending: true)
            .start(afterDocument: lastDocument)
            .limit(to: 10)
            // GET REQUEST
            .getDocumentWithLastDocuments(as: ChatRoomMessagesModel.self)
    }
    
    /// Fetch User Info From 'senderUID' Field.
    func fetchSenderInfo(userUID: String) async throws -> UserProfileModel {
        let userInfo = try await FSCollections.userProfile.document(userUID)
            .getDocument(as: UserProfileModel.self)
        // print("\(userInfo.fullName)'s Data Fetched")
        return userInfo
    }
    
    /// Checks ChatRoom Name Already Exists (In ChatRooms Collection).
    func checkChatRoomExists(roomName: String) async throws -> Bool {
        // GET REQUEST
        let querySnapshot = try await FSCollections.chatRooms.document(roomName).getDocument()
        
        if querySnapshot.exists {
            return false
        } else {
            return true
        }
    }
    
}

