//  MessageCardView.swift
//  Created by Aum Chauhan on 07/08/23.

import SwiftUI
import FirebaseAuth

struct MessageCardView: View {
    
    let message: ChatRoomMessagesModel
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject private var viewModel = ChatRoomViewModel()
    
    @State private var userInfo: UserProfileModel? = nil
    @State private var showTime: Bool = false
    
    init(_ message: ChatRoomMessagesModel) {
        self.message = message
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 13) {
                if usersMessage() {
                    Spacer()
                }
                
                // MARK: Message Content
                VStack(alignment: .leading, spacing: 6) {
                    if !usersMessage() {
                        // MARK: Sent By
                        NavigationLink {
                            UserProfileTabView(user: userInfo, isProfileTab: false)
                        } label: {
                            Text(userInfo?.fullName ?? "")
                                .font(.poppins(.medium, 13))
                                .foregroundColor(.green)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        // MARK: Text
                        Text(message.textSinppet)
                            .font(.poppins(.regular, 14))
                        
                        // MARK: CodeBlock
                        if message.codeBlock.count >= 1 {
                            Text(message.codeBlock)
                                .codeBlockStyle(bgColor: .theme.background)
                        }
                    }
                    .padding(.horizontal, 5)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.theme.primaryTitle)
                }
                .padding(10)
                .background(
                    usersMessage() ? Color.theme.button.opacity(0.4) : Color.theme.secondaryBackground
                )
                .cornerRadius(20)
                
                if !usersMessage() {
                    Spacer()
                }
            }
            .onTapGesture {
                withAnimation {
                    showTime.toggle()
                }
            }
            
            // MARK: Sent At
            if showTime {
                HStack {
                    if usersMessage() {
                        Spacer()
                    }
                    Text(message.sentAt.formatted())
                        .font(.poppins(.regular, 10))
                        .padding(.horizontal, 10)
                    if !usersMessage() {
                        Spacer()
                    }
                }
            }
        }
        .onFirstAppear {
            // MARK: Fetch Sender Info
            Task {
                userInfo = await viewModel.getUserInfo(fromUID: message.senderUID)
            }
        }
    }
    
    func usersMessage() -> Bool {
        return authViewModel.userDetails?.userUID == message.senderUID
    }
}

struct MessageCardView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCardView(Debugging.debuggingMessageContent)
            .environmentObject(AuthenticationViewModel())
    }
}
