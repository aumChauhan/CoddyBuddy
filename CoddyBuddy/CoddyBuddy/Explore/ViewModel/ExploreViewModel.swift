//  ExploreViewModel.swift
//  Created by Aum Chauhan on 01/08/23.

import Foundation
import SwiftUI
import Combine

@MainActor
class ExploreViewModel: ObservableObject {
    
    private let service = ExploreService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var popularPosts: [PostModel] = []
    @Published var users: [UserProfileModel] = []
    @Published var chatRooms: [ChatRoomModel] = []
    @Published var tags: [TagModel] = []
    
    @Published var searchText: String = ""
    
    @Published var errorOccured: Bool = false
    @Published var errorDescription: String = ""
    
    @Published var isLoading: Bool = true
    
    func fetchUsers()  {
        Task {
            do {
                let tempUsers = try await service.findUsers(text: searchText)
                withAnimation {
                    users = tempUsers
                }
            } catch {
                exceptionHandler(error: error)
            }
        }
    }
    
    func getPopularPosts() async {
        do {
            let tempPosts = try await service.fetchPopularPosts()
            withAnimation {
                popularPosts = []
                popularPosts = tempPosts
            }
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func getPopularTags() async {
        do {
            let tempTags = try await service.fetchPopularTags()
            withAnimation {
                tags = tempTags
            }
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func getMostPopularPosts() async {
        do {
            let rooms = try await service.fetchPopularChatRooms()
            withAnimation {
                chatRooms = rooms
            }
        } catch {
            exceptionHandler(error: error)
        }
    }
    
    func fetchAll() {
        Task {
            withAnimation { isLoading = true }
            await getPopularPosts()
            await getPopularTags()
            await getMostPopularPosts()
            withAnimation { isLoading = false }
        }
    }
    private func exceptionHandler(error: Error) {
        errorOccured.toggle()
        errorDescription = error.localizedDescription
        print(error.localizedDescription)
        
        HapticManager.error()
    }
}
