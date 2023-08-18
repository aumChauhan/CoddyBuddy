//  ChatRoomCardView.swift
//  Created by Aum Chauhan on 21/07/23.

import SwiftUI

struct ChatRoomCardView: View {
    
    private let chatRoom: ChatRoomModel?
    private let lineLimit: Int?
    
    @EnvironmentObject var authVM: AuthenticationViewModel
    @StateObject private var viewModel = ChatRoomViewModel()
    
    init(chatRoom: ChatRoomModel? = nil, lineLimit: Int? = nil) {
        self.chatRoom = chatRoom
        self.lineLimit = lineLimit
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 26) {
            
            VStack(alignment: .leading, spacing: 4) {
                // MARK: Chat Room Title
                Text("\(chatRoom?.chatRoomName ?? "....")")
                    .font(.poppins(.semiBold, 16))
                
                // MARK: Chat Room Description
                Text("\(chatRoom?.chatRoomDescription ?? ".....")")
                    .font(.poppins(.regular, 13))
                    .lineLimit(lineLimit ?? nil)
            }
            .multilineTextAlignment(.leading)
            .foregroundColor(.black)
            
            HStack {
                // MARK: Members + Messages
                HStack {
                    Spacer()
                    // MARK: Memeber Count
                    Image("person")
                        .foregroundColor(.gray)
                    Text("\(viewModel.chatRoomListner?.memberCount ?? 0)")
                    
                    Spacer()
                    
                    // MARK: Message Count
                    Image("message1")
                        .foregroundColor(.gray)
                    Text("\(viewModel.messageCount ?? 0)")
                    
                    Spacer()
                }
                .font(.poppins(.regular, 12))
                .foregroundColor(.black)
                .padding(10)
                .bgFillToInfinity(bgColor: .white.opacity(0.9))
                
                
                Button {
                    Task {
                        // MARK: Join Leave Action
                        if authVM.isAlreadyJoined(chatRoom?.chatRoomName ?? "") {
                            await viewModel.leaveChatRoom(chatRoomName: chatRoom?.chatRoomName ?? "")
                        } else {
                            await viewModel.joinChatRooms(chatRoomName: chatRoom?.chatRoomName ?? "")
                        }
                    }
                } label: {
                    HStack {
                        Image("people")
                        
                        Text(authVM.isAlreadyJoined(chatRoom?.chatRoomName ?? "") ? "Leave" : "Join")
                    }
                    .font(.poppins(.medium, 14))
                    .foregroundColor(.white)
                    .padding(20)
                    .dynamicBgFill(bgColor: .black.opacity(0.75))
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color("\(chatRoom?.chatRoomColorPalette ?? "ColorGreen")"))
        .cornerRadius(20)
        // MARK: Fetch Request
        .onFirstAppear {
            Task {
                viewModel.attachListnerToChatRooms(chatRoom: chatRoom?.chatRoomName ?? "nil")
                await viewModel.getMessageCount(chatRoomName: chatRoom?.chatRoomName ?? "nil")
            }
        }
    }
}

extension ChatRoomCardView {
    var cellViewForChatTab: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 0){
                Text("\(chatRoom?.chatRoomName ?? "Unknown Name")")
                    .font(.poppins(.medium, 16))
                    .foregroundColor(.theme.primaryTitle)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
}

struct ChatRoomCardView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomCardView(chatRoom: Debugging.debuggingChatRoom, lineLimit: 2)
            .environmentObject(AuthenticationViewModel())
    }
}
