//  ChatRoomMessagesView.swift
//  Created by Aum Chauhan on 26/07/23.

import SwiftUI
import AlertToast

struct ChatRoomMessagesView: View {
    
    let title: String
    
    @EnvironmentObject var authVM: AuthenticationViewModel
    @StateObject private var viewModel = ChatRoomViewModel()
    
    @State var messageAppend: Bool = false
    @State var newMessage: ChatRoomMessagesModel? = nil
    
    var body: some View {
        VStack {
            header
            
            if viewModel.allMessages.isEmpty {
                VStack {
                    noPostFound("🙁 No messages have been posted in this channel. ")
                    Spacer()
                }
            } else {
                messages
            }
            
            if authVM.isAlreadyJoined(title) {
                textField
            } else {
                joinChatRoomButton
            }
        }
        .padding(.bottom, 10)
        .background(Color.theme.background.ignoresSafeArea())
        .onFirstAppear {
            Task {
                await viewModel.messageListner(chatRoom: title)
            }
        }
        /*
        .onReceive(viewModel.$allMessages.dropFirst(), perform: { newMessage in
            messageAppend = true
            self.newMessage = newMessage.first
        })
         */
        .navigationBarBackButtonHidden()
        
        // MARK: Message Notfications
        /*
        .toast(isPresenting: $messageAppend) {
            AlertToast(
                displayMode: .banner(.slide),
                type: .regular,
                title: "\(title)",
                subTitle: "\(newMessage?.textSinppet ?? "")",
                style: .style(backgroundColor: .green, titleColor: .white, subTitleColor: .white)
            )
        }
         */
    }
}

extension ChatRoomMessagesView {
    
    // MARK: Header
    private var header: some View {
        HStack {
            DismissButtonView(imageName: "arrowLeft", frameSize: iconHeight)
            Spacer()
            
            // Title
            Text(title)
                .font(.poppins(.medium, 18))
            Spacer()
            
            // Menu
            Menu {
                Button(role: .destructive) {
                    // MARK: Leave Channel Action
                    Task {
                        await viewModel.leaveChatRoom(chatRoomName: title)
                    }
                } label: {
                    Text("Are You Sure?")
                }
            } label: {
                Image("share")
                    .rotationEffect(Angle(degrees: 90))
                    .foregroundColor(.theme.icon)
                    .circularButton(frameSize: iconHeight)
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: Messages
    private var messages: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(viewModel.allMessages, id: \.self) { message in
                    MessageCardView(message)
                        .padding(.horizontal, 10)
                    if (message == viewModel.allMessages.last && viewModel.lastSnapDocForMessages != nil) {
                        ProgressView()
                            .onFirstAppear {
                                Task {
                                    // MARK: Append More Messages
                                    await viewModel.appendMoreMessages(chatRoom: title)
                                }
                            }
                    }
                }
                .rotationEffect(Angle(degrees: 180))
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .rotationEffect(Angle(degrees: 180))
        .padding(.horizontal, 5)
        
    }
    
    // MARK: TextField
    private var textField: some View {
        HStack(alignment: .bottom) {
            TextField("Message", text: $viewModel.messageTextSinppet, axis: .vertical)
                .padding(14)
                .frame(maxWidth: .infinity)
                .background( Color.theme.secondaryBackground)
                .cornerRadius(24)
            
            Button {
                Task {
                    // MARK: Publish Message Action
                    await viewModel.postMessageToRoom(chatRoom: title)
                    viewModel.messageTextSinppet = ""
                    HapticManager.light()
                }
            } label: {
                Image("send")
                    .contrast(2)
                    .foregroundColor(.white)
                    .circularGradientButton(frameSize: 48)
            }
            .disabled(!ValidationService.isValidSearchText(viewModel.messageTextSinppet))
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: Join ChatRoom Button  
    private var joinChatRoomButton: some View {
        HStack {
            Button {
                Task {
                    // MARK: Join ChatRoom Action
                    await viewModel.joinChatRooms(chatRoomName: title)
                }
            } label: {
                Text("Join Channel")
                    .font(.poppins(.semiBold, 16))
                    .foregroundColor(.white)
                    .gradientFillToInfinity(height: 48)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct ChatRoomMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomMessagesView(title: "Swift")
            .environmentObject(AuthenticationViewModel())
    }
}


