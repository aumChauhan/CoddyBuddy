import SwiftUI

struct AskBotView: View {
    
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("chatBotIcon") var chatBotIcon: String = "bot"
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    @AppStorage("toggleChatBot") var toggleChatBot: Bool = true
    @AppStorage("chatBotAlert") var chatBotAlert: Bool = true
    @AppStorage("playSoundOnCopied") var playSoundOnCopied: Bool = true
    @AppStorage("ChatBackgroundName") var ChatBackgroundName: String = ""
    let link = URL(string: "https://www.coddybuddy.com")!
    let pasteboard = UIPasteboard.general
    
    @ObservedObject var Obj_VM_ChatBot = ChatBotViewModel()
    @State var userMessage = ""
    @State var botReply: [String] = []
    @State var toggleBackgroundSheet: Bool = false
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                if !toggleChatBot {
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 25, height: 5)
                            .foregroundColor(.white.opacity(0.6))
                        Spacer()
                    }
                    .padding(10)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Image(chatBotIcon)
                                .resizable()
                                .frame(width: 18, height: 18)
                                .font(.title)
                                .foregroundColor(Color(selectedColor))
                                .padding(6)
                                .background(.white)
                                .cornerRadius(100)
                            
                            Text("ChatBot")
                                .font(.title)
                                .fontWeight(.bold)
                                .shadow(radius: 20)
                        }
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Menu {
                        Button(role: .destructive) {
                            withAnimation {
                                botReply = []
                                if toggleHaptics {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                }
                            }
                        } label: {
                            HStack {
                                Text("Clear")
                                Spacer()
                                Image(systemName: "trash")
                            }
                        }
                    } label: {
                        ZStack {
                            Image(systemName: "ellipsis.circle").opacity(0.0)
                            
                            Image(systemName: "ellipsis")
                        }
                        .font(.title3)
                        .padding(4)
                        .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.vertical, toggleChatBot ? 16 : 0)
                .padding(.bottom, toggleChatBot ? 2 : 12)
                
                VStack {
                    ScrollView {
                        ForEach(botReply, id: \.self) { index in
                            if index.contains("[USER]") {
                                let newMessage = index.replacingOccurrences(of: "[USER]", with: "")
                                Menu {
                                    ShareLink("Share",
                                              item: "\(newMessage)"
                                    )
                                    .onTapGesture {
                                        if toggleHaptics {
                                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                        }
                                    }
                                    Button {
                                        pasteboard.string = "\(newMessage)"
                                        if toggleHaptics {
                                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                        }
                                        if playSoundOnCopied {
                                            SoundPlayer.playSound()
                                        }
                                    } label: {
                                        HStack {
                                            Text("Copy")
                                            Image(systemName: "doc.on.doc")
                                        }.foregroundColor(.red)
                                    }
                                } label: {
                                    HStack {
                                        Spacer()
                                        Text(newMessage)
                                            .foregroundColor(.white)
                                            .fontWeight(.regular)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal,14)
                                            .background(Color(selectedColor))
                                            .cornerRadius(22)
                                            .padding(.horizontal, 12)
                                            .padding(.top, 4)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding(.horizontal, 6)
                                }
                                .onTapGesture {
                                    if toggleHaptics {
                                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                    }
                                }
                                
                            }
                            else {
                                Menu {
                                    ShareLink("Share",
                                              item: "\(index)"
                                    )
                                    .onTapGesture {
                                        if toggleHaptics {
                                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                        }
                                    }
                                    Button {
                                        pasteboard.string = "\(index)"
                                        if toggleHaptics {
                                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                        }
                                        if playSoundOnCopied {
                                            SoundPlayer.playSound()
                                        }
                                    } label: {
                                        HStack {
                                            Text("Copy")
                                            Image(systemName: "doc.on.doc")
                                        }.foregroundColor(.red)
                                    }
                                } label: {
                                    HStack {
                                        Text(index.trimmingCharacters(in: .whitespaces))
                                            .fontWeight(.regular)
                                            .padding(12)
                                            .background(Color(uiColor: .secondarySystemBackground))
                                            .cornerRadius(20)
                                            .padding(.horizontal, 12)
                                            .padding(.top, 4)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 6)
                                }.tint(.primary)
                                    .onTapGesture {
                                        if toggleHaptics {
                                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                        }
                                    }
                            }
                        }
                        .rotationEffect(.degrees(180))
                    }
                    .rotationEffect(.degrees(180))
                    
                    HStack {
                        TextField("Ask ChatBot...", text: $userMessage)
                            .padding(10)
                            .padding(.horizontal, 8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(20)
                            .tint(Color(selectedColor))
                        
                        withAnimation {
                            Button {
                                sendMessage(userMessage: userMessage)
                                if toggleHaptics {
                                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                }
                            } label: {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color(selectedColor))
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(17)
                }
                .padding(.top, 30)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.init(uiColor: .systemBackground))
                .cornerRadius(toggleChatBot ? 25 : 10)
            }
        }
        .onAppear {
            Obj_VM_ChatBot.setup()
        }
        
        .navigationBarBackButtonHidden(true)
        .background(LinearGradient(colors: [Color(selectedColor).opacity(0.85), Color(selectedColor).opacity(0.85), Color(uiColor: .systemBackground)], startPoint: .top, endPoint: .bottom))
    }
    
    func sendMessage(userMessage: String) {
        guard !userMessage.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        withAnimation {
            botReply.append("[USER]" + userMessage)
            self.userMessage = ""
        }
        
        Obj_VM_ChatBot.userMessage(message: userMessage) { botReply in
            DispatchQueue.main.async {
                withAnimation {
                    self.botReply.append("\(botReply)")
                    self.userMessage = ""
                }
            }
        }
    }
    
    func validText(message: String) -> Bool {
        if message.count > 2 {
            return true
        }
        return false
    }
}

struct AskBotView_Previews: PreviewProvider {
    static var previews: some View {
        AskBotView()
    }
}

