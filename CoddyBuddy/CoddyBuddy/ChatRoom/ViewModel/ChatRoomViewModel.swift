//  ChatRoomViewModel.swift
//  Created by Aum Chauhan on 22/07/23.

import UIKit
import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore

enum ChatRoomFilters: String, CaseIterable {
    case joined = "Joined"
    case explore = "Explore"
    case search = "Search"
}

@MainActor
class ChatRoomViewModel: ObservableObject {
    
    private let service = ChatRoomService()
    private let userDataService = UserDataService()
    private let storageService = FireStoreStorageService()
    
    var lastSnapDoc: DocumentSnapshot? = nil
    var lastSnapDocForMessages: DocumentSnapshot? = nil
    
    private(set) var chatRoomNote: String = "❥ Remember, it's an open forum. So, Anyone can join the chat and participate.\n❥ Your name will be linked as the chat's creator—props to you!\n❥ Once created, chatrooms are here to stay. They can't be deleted."
    
    private let colorSetsForChatRoom: [String] = [
        "ColorBlue", "ColorBrown", "ColorGray", "ColorGreen", "ColorMint", "ColorPink", "ColorPurple", "ColorYellow" ]
    
    @Published var chatRoomName: String = ""
    @Published var chatRoomDescription: String = ""
    @Published var allChatRooms: [ChatRoomModel] = []
    @Published var chatRoomInfo: ChatRoomModel? = nil
    
    @Published var messageTextSinppet: String = ""
    @Published var messageCodeBlock: String = ""
    @Published var messageURLString: String = ""
    
    @Published var errorOccured: Bool = false
    @Published var errorDescription: String = ""
    
    @Published var allMessages: [ChatRoomMessagesModel] = []
    @Published var chatRoomCreaterInfo: UserProfileModel? = nil
    
    @Published var searchText: String = ""
    @Published var messageCount: Int? = 0
    
    @Published var chatRoomListner: ChatRoomModel? = nil
    @Published var filterType: ChatRoomFilters = .joined
    
    @Published var chatRoomCreated: Bool = false
    @Published var isLoading: Bool = true
    
    func createChatRoom(image: UIImage?) async {
        //func createRoom() async {
        do {
            guard let userSession = Auth.auth().currentUser else {
                throw URLError(.userAuthenticationRequired)
            }
            
            guard ValidationService.isValidName(chatRoomName) else {
                throw ValidationError.invalidName
            }
            
            guard chatRoomName.count < 16 else {
                throw ValidationError.chatRoomNameLimitExceeds
            }
            
            guard chatRoomDescription.count < 100 else {
                throw ValidationError.descriptionExceeds
            }
            
            guard chatRoomDescription.count > 10 else {
                throw ValidationError.descriptionTooSmall
            }
            
            let chatRoomExists = try await service.checkChatRoomExists(roomName: chatRoomName)
            
            guard chatRoomExists else {
                throw ValidationError.chatRoomAlreadyExists
            }
            
            let chatRoom = ChatRoomModel(
                createdBy: userSession.uid,
                createdOn: Date(),
                chatRoomName: chatRoomName.capitalized.trimmingCharacters(in: .whitespacesAndNewlines),
                memberCount: 0,
                chatRoomDescription: chatRoomDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                membersUIDs: [],
                chatRoomColorPalette: colorSetsForChatRoom.randomElement() ?? "ColorYellow",
                chatRoomProfileURLString: "")
            
            try await service.createChatRoom(chatRoom: chatRoom)
            // try await uploadImage(image: image)
            
            HapticManager.success()
            chatRoomCreated.toggle()
        } catch  {
            exceptionHandler(error: error)
        }
    }
    
    private func uploadImage(image: UIImage) async throws {
        do {
            let urlString = try await storageService.setImageToFirestore(image: image, path: .chatRoomProfile)
            print(urlString ?? "no url found")
            
            try await service.updateChatRoomProfileURL(chatRoom: chatRoomName, imageURL: urlString ?? "")
            
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func getChatRooms(emptyChatRooms: Bool) async {
        do {
            withAnimation { isLoading = true }
            guard let userSession = Auth.auth().currentUser else {
                throw URLError(.userAuthenticationRequired)
            }
            
            if emptyChatRooms {
                allChatRooms = []
                lastSnapDoc = nil
            }
            
            let (newChatRooms, lastDoc) = try await service.fetchChatRooms(userUID: userSession.uid, filter: filterType, searchText: searchText, lastDocument: lastSnapDoc)
            
            withAnimation {
                self.allChatRooms.append(contentsOf: newChatRooms)
                self.lastSnapDoc = lastDoc
                isLoading = false
            }
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func attachListnerToChatRooms(chatRoom: String) {
        FSCollections.chatRooms.document(chatRoom)
            .addSnapshotListener { [weak self] snapShot , error in
                let decodedPost = try? snapShot?.data(as: ChatRoomModel.self)
                withAnimation {
                    self?.chatRoomListner = decodedPost
                }
            }
    }
    
    func getUserInfo(fromUID: String) async -> UserProfileModel? {
        return try? await userDataService.getUserData(fromUID: fromUID)
    }
    
    func joinChatRooms(chatRoomName: String) async {
        do {
            HapticManager.soft()
            guard let userSession = Auth.auth().currentUser else {
                throw URLError(.userAuthenticationRequired)
            }
            
            try await service.joinChatRoom(userUID: userSession.uid, chatRoomName: chatRoomName)
            
            try await userDataService.appendToJoinChatRoomField(userUID: userSession.uid, chatRoomName: chatRoomName)
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func leaveChatRoom(chatRoomName: String) async {
        do {
            HapticManager.soft()
            guard let userSession = Auth.auth().currentUser else {
                throw URLError(.userAuthenticationRequired)
            }
            
            try await service.leaveChatRoom(userUID: userSession.uid, chatRoomName: chatRoomName)
            
            try await userDataService.removeFromJoinChatRoomsField(userUID: userSession.uid, chatRoomName: chatRoomName)
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func getChatRoomDetails(chatRoomName: String) async {
        do {
            let tempInfo = try await service.fetchChatRoomInfo(chatRoomName: chatRoomName)
            withAnimation {
                chatRoomInfo = tempInfo
            }
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    // MARK: Messages
    func postMessageToRoom(chatRoom: String) async {
        do {
            try await service.postMessageToChatRoom(
                chatRoomName: chatRoom,
                textSnippet: messageTextSinppet.trimmingCharacters(in: .whitespacesAndNewlines),
                codeBlock: messageCodeBlock.trimmingCharacters(in: .whitespacesAndNewlines),
                urlString: messageURLString.trimmingCharacters(in: .whitespacesAndNewlines))
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func messageListner(chatRoom: String) async {
        await service.fetchMessageInitialRequest(chatRoom: chatRoom) { [weak self] (messages, lastDoc) in
            if let messages {
                withAnimation {
                    self?.allMessages = messages
                    self?.lastSnapDocForMessages = lastDoc
                }
            } else {
                // TODO: Handle NULL Values
            }
        }
    }
    
    func appendMoreMessages(chatRoom: String) async {
        do {
            let (newMessages, lastDoc) = try await service.appendMessages(chatRoom: chatRoom, lastDocument: lastSnapDocForMessages)
            
            guard let newMessages = newMessages else {
                throw URLError(.badServerResponse)
            }
            
            withAnimation {
                self.allMessages.append(contentsOf: newMessages)
                self.lastSnapDocForMessages = lastDoc
            }
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func getMessageCount(chatRoomName: String) async {
        let tempMessageCount = try? await service.getMessageCount(for: chatRoomName)
        withAnimation {
            messageCount = tempMessageCount
        }
    }
    
    func fetchChatRoomOwnersInfo(userUID: String) async {
        do {
            let tempOwnerInfo = try await service.getChatRoomOwnersInfo(userUID: userUID)
            withAnimation {
                chatRoomCreaterInfo = tempOwnerInfo
            }
        } catch {
            errorDescription = error.localizedDescription
        }
    }
    
    private func exceptionHandler(error: Error) {
        errorOccured.toggle()
        errorDescription = error.localizedDescription
        HapticManager.error()
    }
}

