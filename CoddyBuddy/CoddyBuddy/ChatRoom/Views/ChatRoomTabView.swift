//  ChatRoomTabView.swift
//  Created by Aum Chauhan on 17/07/23.

import SwiftUI

struct ChatRoomTabView: View {
    
    private let filterOptions = [ ("Joined", 1), ("Explore", 2)]
    @StateObject private var viewModel = ChatRoomViewModel()
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedFilter: Int = 1
    @State private var showCreateChatRoomSheet: Bool = false
    @State private var showSearchBar: Bool = false
    
    var body: some View {
        NavigationHeaderView(title: "ChatRooms") {
            if viewModel.isLoading {
                skelton
            } else if viewModel.filterType == .joined && viewModel.allChatRooms.isEmpty {
                noPostFound("🙁 It seems you haven't joined any chatrooms.")
            } else if viewModel.filterType == .search && viewModel.allChatRooms.isEmpty {
                noPostFound("🙁 No chatrooms found for your search: \(viewModel.searchText).")
            } else {
                allChatRooms
            }
            
        } topLeading: {
            leadingButton
            
        } topTrailing: {
            trailingButton
            
        } subHeader: {
            searchBarSegmentedControl
        }
        // MARK: Initial Fetch Request
        .onFirstAppear {
            Task {
                await viewModel.getChatRooms(emptyChatRooms: false)
            }
        }
        
        // MARK: Create New ChatRoom Sheet
        .sheet(isPresented: $showCreateChatRoomSheet) {
            CreateNewChatRoomView()
        }
        
        // MARK: Fetch Request On Basis Of Selected FIlter
        .onChange(of: selectedFilter) { oldValue,newValue in
            if newValue == 1 {
                viewModel.filterType = .joined
                Task {
                    await viewModel.getChatRooms( emptyChatRooms: true)
                }
            } else {
                viewModel.filterType = .explore
                Task {
                    await viewModel.getChatRooms(emptyChatRooms: true)
                }
            }
        }
    }
}

extension ChatRoomTabView {
    
    // MARK: Leading Toolbar Content
    private var leadingButton: some View {
        Button {
            showCreateChatRoomSheet.toggle()
        } label: {
            Image("peoplePencil")
                .foregroundColor(.theme.icon)
                .circularButton(frameSize: iconHeight)
        }
    }
    
    // MARK: Trailing Toolbar Content
    private var trailingButton: some View {
        Button {
            withAnimation {
                showSearchBar.toggle()
            }
        } label: {
            Image(showSearchBar ? "filter-add" : "magnifyingGlass")
                .foregroundColor(.theme.icon)
                .circularButton(frameSize: iconHeight)
        }
    }
    
    // MARK: Chat Rooms Feed
    private var allChatRooms: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.allChatRooms, id: \.self) { chatRoom in
                NavigationLink {
                    ChatRoomMessagesView(title: chatRoom.chatRoomName)
                        .toolbar(.hidden)
                } label: {
                    ChatRoomCardView(chatRoom: chatRoom, lineLimit: nil)
                        .multilineTextAlignment(.leading)
                }
                if (chatRoom == viewModel.allChatRooms.last && viewModel.lastSnapDoc != nil) {
                    ProgressView()
                        .onAppear {
                            // MARK: Fetch Request
                            Task {
                                await viewModel.getChatRooms(emptyChatRooms: false)
                            }
                        }
                }
            }
        }
        .padding(.bottom, 60)
    }
    
    // MARK: Search Bar + Segmented Control
    private var searchBarSegmentedControl: some View {
        ZStack {
            if showSearchBar {
                HStack {
                    SearchBarView(text: $viewModel.searchText, showAutoKeyboardDismiss: false)
                        .onDisappear {
                            Task {
                                selectedFilter = 1
                                await viewModel.getChatRooms(emptyChatRooms: true)
                            }
                        }
                    
                    if ValidationService.isValidSearchText(viewModel.searchText) {
                        // MARK: Search Chat Room
                        Button {
                            Task {
                                viewModel.filterType = .search
                                await viewModel.getChatRooms(emptyChatRooms: true)
                            }
                        } label: {
                            Text("Search")
                                .inverseDynamicBackground()
                        }
                    }
                }
            } else {
                SegmentedControlView(tabs: filterOptions, selectedTab: $selectedFilter, height: 48)
            }
        }
    }
    
    // MARK: Skelton
    private var skelton: some View {
        VStack {
            ForEach(0..<2) { item in
                HStack {
                    Lottie(fileName: "chatRoomSkelton")
                        .padding(.top, 13)
                }
                .opacity(colorScheme == .light ? 1.0 : 0.1)
                .frame(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.width * 1.2)
                .scaleEffect(1.1)
            }
        }
    }
}

struct ChatRoomTabs_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChatRoomTabView()
                .environmentObject(AuthenticationViewModel())
        }
    }
}
