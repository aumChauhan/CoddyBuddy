////  ChatRoomDetailsView.swift
////  Created by Aum Chauhan on 08/08/23.
//
//import SwiftUI
//
//struct ChatRoomDetailsView: View {
//    
//    let title: String
//    
//    @StateObject private var viewModel = ChatRoomViewModel()
//    
//    var body: some View {
//            VStack(alignment: .leading, spacing: 16) {
//                VStack(alignment: .leading) {
//                    Text(viewModel.chatRoomInfo?.chatRoomName ?? "....")
//                        .font(.poppins(.medium, 18))
//                        .foregroundColor(.theme.primaryTitle)
//                    
//                    CustomDivider()
//                    
//                    Text(viewModel.chatRoomInfo?.chatRoomDescription ?? "...")
//                        .font(.poppins(.regular, 14))
//                        .foregroundColor(.theme.secondaryTitle)
//                        .padding(.top, 4)
//                }
//                .padding(16)
//                .background(Color.theme.secondaryBackground)
//                .cornerRadius(24)
//                
//                HStack {
//                    Text("Created By : \(viewModel.chatRoomCreaterInfo?.fullName ?? "....")")
//                    Spacer()
//                    
//                    Image(systemName: "chevron.right")
//                        .foregroundColor(.theme.icon)
//                }
//                .padding(16)
//                .font(.poppins(.medium, 14))
//                .bgFillToInfinity(height: 60, bgColor: .theme.secondaryBackground, radius: 24)
//
//                HStack {
//                    Group {
//                        HStack {
//                            Image("person")
//                            Text("\(viewModel.chatRoomInfo?.memberCount ?? 0)")
//                        }
//                        
//                        HStack {
//                            Image("message")
//                            Text("\(viewModel.messageCount ?? 0)")
//                        }
//                    }
//                    .font(.poppins(.medium, 14))
//                    .foregroundColor(.theme.primaryTitle)
//                    .bgFillToInfinity(height: 55, bgColor: .theme.secondaryBackground, radius: 24)
//                }
//                 
//                /*
//                VStack(alignment: .leading) {
//                    Text("Joind Members")
//                        .font(.poppins(.medium, 14))
//                    ScrollView {
//                        UserInfoCellView2(user: Debugging.debuugingProfile)
//                            .padding(10)
//                            .backgroundFill(height: 65, bgColor: .theme.secondaryBackground, radius: 24)
//                    }
//                }
//                 Spacer()
//                */
//            }
//            .padding(.top, 10)
//            .padding(20)
//            .background(Color.theme.background.ignoresSafeArea())
//            
//        .onFirstAppear {
//            Task {
//                await viewModel.getChatRoomDetails(chatRoomName: title)
//                await viewModel.fetchChatRoomOwnersInfo(userUID: viewModel.chatRoomInfo?.createdBy ?? "nil")
//                await viewModel.getMessageCount(chatRoomName: title)
//            }
//        }
//    }
//}
//
//struct ChatRoomDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRoomDetailsView(title: "Apple")
//    }
//}
//
//    .sheet(isPresented: $showChatRoomDetails) {
//        ChatRoomDetailsView(title: title)
//        
//        // MARK: SOURCE ->  https://stackoverflow.com/questions/74471576/make-sheet-the-exact-size-of-the-content-inside
//            .overlay {
//                GeometryReader { geometry in
//                    Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
//                }
//            }
//            .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
//                sheetHeight = newHeight
//            }
//            .presentationDetents([.height(sheetHeight)])
//            .presentationCornerRadius(20)
//            .presentationDragIndicator(.visible)
//        
//    }
