import SwiftUI
import UIKit

struct ReplyView: View {
    
    let link = URL(string: "https://www.coddybuddy.com")!
    let pasteboard = UIPasteboard.general
    
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    @AppStorage("playSoundOnCopied") var playSoundOnCopied: Bool = true
    
    @State var question: String = ""
    @State var code: String = ""
    @State var toggle_ReplySheet: Bool = false
    @State var deleteAlertToggle: Bool = false
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    
    @ObservedObject var ViewModel_Question_Feed_Row: Question_Feed_SingleRow_ViewModel
    @ObservedObject var fetchReplies: Fetch_RepliesViewModel
    @ObservedObject var Reply_Feed_SingleRow_ViewModel_Obj: Reply_Feed_SingleRow_ViewModel
    @ObservedObject var Fetching_Object = FetchUserQueriesOn_HomeTab_ViewModel()
    @ObservedObject var ReplyAnswerViewModel_Object : ReplyAnswerViewModel
    
    init(questionPost: PostedQuery_MetaData) {
        self.ViewModel_Question_Feed_Row = Question_Feed_SingleRow_ViewModel(questionPost: questionPost)
        self.fetchReplies = Fetch_RepliesViewModel(questionPost: questionPost)
        self.Reply_Feed_SingleRow_ViewModel_Obj = Reply_Feed_SingleRow_ViewModel(replyPost: questionPost)
        self.ReplyAnswerViewModel_Object = ReplyAnswerViewModel(questionPost: questionPost)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack {
                    Question_Post_View_IN_Reply(questionPost: ViewModel_Question_Feed_Row.postedQuestion)
                    HStack {
                        Text("Replies")
                            .foregroundColor(.primary)
                            .font(.headline)
                            .padding(5)
                            .padding(.horizontal, 10)
                        Spacer()
                    }
                    RoundedRectangle(cornerRadius: 1)
                        .frame(height: 1)
                        .foregroundColor(Color(uiColor: .secondarySystemBackground))
                }
                
                ForEach(fetchReplies.fetchedReplyDataArray) { indexin in
                    VStack(alignment: .leading) {
                        HStack(alignment: .top, spacing: 12) {
                            if indexin.user?.showProfilePic ?? false {
                                OnlyProfilePhotoView(url: indexin.user?.profilePicURL ?? "", key: indexin.user?.id ?? "")
                            } else {
                                RoundedRectangle(cornerRadius: 11)
                                    .fill((LinearGradient(colors: [Color(indexin.user?.randomColorProfile ?? ""), Color(indexin.user?.randomColorProfile ?? "").opacity(0.7)], startPoint: .top, endPoint: .bottom)))
                                    .frame(width: 45, height:45)
                                    .cornerRadius(11)
                                    .overlay {
                                        Image("anonymousicon2")
                                            .resizable()
                                            .frame(width: 26, height: 26)
                                            .foregroundColor(.white.opacity(0.7))
                                            .scaledToFill()
                                    }
                            }
                            
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .top,spacing: 0) {
                                    HStack(alignment: .center,spacing: 3) {
                                        Text(indexin.user?.anonymousName ?? false ? "Anonymous": indexin.user?.fullName ?? "")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        
                                        Image(systemName: indexin.user?.isVerfied ?? false ? "checkmark.seal.fill" : "")
                                            .foregroundColor(.teal)
                                            .font(.caption)
                                        Spacer()
                                        HStack {
                                            Menu {
                                                ShareLink(
                                                    "Share",
                                                    item:"Question :\n\(indexin.reply)\n\nCodeBlock :\n\(indexin.codeBlock)\n\n\(link)"
                                                )
                                                .onTapGesture {
                                                    if toggleHaptics {
                                                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                                    }
                                                }
                                                
                                                Button {
                                                    pasteboard.string = "Question :\n\(indexin.reply)\n\nCodeBlock :\n\(indexin.codeBlock)"
                                                    if toggleHaptics {
                                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
                                                
                                                if (indexin.user?.id ?? "" == AuthenticationObject.currentUserData?.id) {
                                                    Divider()
                                                    Menu {
                                                        Button(role: .destructive) {
                                                            withAnimation {
                                                                ReplyAnswerViewModel_Object.deleteReply(Reply: indexin)
                                                                fetchReplies.fetchUserReply()
                                                            }
                                                            if toggleHaptics {
                                                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                                                            }
                                                        } label: {
                                                            Text("Confirm ?")
                                                        }
                                                    } label: {
                                                        HStack {
                                                            Text("Delete My Reply")
                                                            Image(systemName: "trash")
                                                        }
                                                    }
                                                }
                                            } label: {
                                                ZStack {
                                                    Image(systemName: "ellipsis.circle").opacity(0.0)
                                                        .font(.headline)
                                                    Image(systemName: "ellipsis")
                                                        .font(.caption)
                                                        .padding(.horizontal, 6)
                                                        .padding(.bottom, 5)
                                                }
                                                .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                }
                                
                                HStack(alignment: .center,spacing: 5){
                                    Text("@\(indexin.user?.anonymousUserName ?? false ? String("anonymous_"+(indexin.user?.id?.prefix(5) ?? "")) : indexin.user?.userName ?? "")")
                                        .font(.caption)
                                        .fontWeight(.thin)
                                        .foregroundColor(.primary)
                                    
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 3))
                                        .foregroundColor(.gray)
                                        .opacity(0.8)
                                    
                                    Text(indexin.replyPostedOn.dateValue().formatted(date: .numeric, time: .omitted))
                                        .font(.caption)
                                        .fontWeight(.thin)
                                        .opacity(0.7)
                                }
                                
                                VStack(alignment: .leading,spacing:0){
                                    Text(indexin.reply)
                                        .textSelection(.enabled)
                                        .font(.system(size: 13.5))
                                        .padding(.bottom, 7)
                                        .padding(.top, 2)
                                    
                                    if indexin.codeBlock.count >= 1 {
                                        if #available(iOS 16.1, *) {
                                            Text(indexin.codeBlock)
                                                .textSelection(.enabled)
                                                .fontDesign(.monospaced)
                                                .font(.system(size: 12))
                                                .padding(7)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(Color(uiColor: .secondarySystemBackground))
                                                .cornerRadius(8)
                                        } else {
                                            Text(indexin.codeBlock)
                                                .textSelection(.enabled)
                                                .fontWeight(.medium)
                                                .font(.system(size: 12))
                                                .padding(7)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(Color(uiColor: .secondarySystemBackground))
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                                .padding(.top, 4)
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    
                    RoundedRectangle(cornerRadius: 1)
                        .frame(height: 1)
                        .foregroundColor(Color(uiColor: .secondarySystemBackground))
                }
                
            }
            .refreshable {
                fetchReplies.fetchUserReply()
            }
            HStack{
                Spacer()
                Button {
                    withAnimation {
                        toggle_ReplySheet.toggle()
                        if toggleHaptics {
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        }
                    }
                } label: {
                    HStack(spacing:2) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("Reply")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding(10)
                    .padding(.horizontal, 4)
                    .background(Color(selectedColor))
                    .cornerRadius(200)
                    .padding(17)
                    .padding(.bottom, 11)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(
            isPresented: $toggle_ReplySheet
            ,onDismiss: { fetchReplies.fetchUserReply() }) {
                ReplyTOQuestionView(questionPost: ViewModel_Question_Feed_Row.postedQuestion)
                    .interactiveDismissDisabled(true)
            }
            .interactiveDismissDisabled(true)
    }
}


struct ReplyTOQuestionView: View{
    
    @State var queryString: String = ""
    @State var codeBlockString: String = ""
    @State var alertToggle: Bool = false
    
    @State var tabCategory: [String] = ["Reply Block", "Code Block"]
    @State var tabSelected: String = "Reply Block"
    @Namespace private var namepsace
    
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    
    @Environment(\.presentationMode) var dismissButton
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @ObservedObject var PostQueryViewModel_Object = PostQueryViewModel()
    @ObservedObject var Fetching_Object = FetchUserQueriesOn_HomeTab_ViewModel()
    
    @ObservedObject var obj: ReplyAnswerViewModel
    @State var previewSheetToogle: Bool = false
    @State var toggleOptionButton: Bool = false
    @State var tagItemForTabView: Int = 1
    
    init(questionPost: PostedQuery_MetaData) {
        self.obj = ReplyAnswerViewModel(questionPost: questionPost)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 0) {
                        HStack(spacing: 9) {
                            OnlyProfilePhotoView(url: AuthenticationObject.currentUserData?.profilePicURL ?? "", key: AuthenticationObject.currentUserData?.id ?? "")
                            
                            VStack(alignment: .leading, spacing: 0){
                                HStack(alignment: .center, spacing: 3){
                                    Text("\(AuthenticationObject.currentUserData?.fullName ?? "")")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    
                                    Image(systemName: AuthenticationObject.currentUserData?.isVerfied ?? false ? "checkmark.seal.fill" : "")
                                        .foregroundColor(.teal)
                                        .font(.caption)
                                }
                                Text("@\(AuthenticationObject.currentUserData?.userName ?? "")")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(10)
                        .frame(width: UIScreen.main.bounds.width/1.1)
                        .background(Color.init(uiColor: .secondarySystemBackground))
                        .cornerRadius(15)
                        .padding(.horizontal, 15)
                        
                        .padding(.top, 15)
                        .padding(.bottom, 2)
                        
                        TabView(selection: $tabSelected) {
                            postQuestionTextFieldForReply
                                .tag("Reply Block")
                            
                            codeBlockTextFieldForReply
                                .tag("Code Block")
                        }
                        
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(width: UIScreen.main.bounds.width/1.1, height:  UIScreen.main.bounds.width/1.2)
                        .padding(.horizontal, 15)
                    }
                }
                
                HStack {
                    ForEach(tabCategory, id: \.self) { index in
                        ZStack {
                            if tabSelected == index {
                                RoundedRectangle(cornerRadius: 100)
                                    .foregroundColor(Color(selectedColor))
                                    .matchedGeometryEffect(id: "Tabs", in: namepsace)
                            }
                            Text("     \(index)     ")
                                .fontWeight(tabSelected == index ? .semibold : .regular)
                                .foregroundColor(tabSelected == index ? .white : .gray)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        tabSelected = index
                                    }
                                }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                    }
                }
                .frame(width: UIScreen.main.bounds.width/1.1)
                .background(Color.init(.secondarySystemBackground))
                .cornerRadius(100)
                .padding(.bottom, 14)
                .padding(.horizontal, 15)
            }
            
            .navigationTitle("Add Reply")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        withAnimation {
                            dismissButton.wrappedValue.dismiss()
                            if toggleHaptics {
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                            }
                        }
                    }, label: {
                        Text("Cancel")
                            .foregroundColor(Color(selectedColor))
                    })
                
                ,trailing:
                    Button {
                        obj.postReplyDB(withReply: queryString.trimmingCharacters(in: .whitespacesAndNewlines), codeBlock: codeBlockString.trimmingCharacters(in: .whitespacesAndNewlines))
                        if toggleHaptics {
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        }
                    } label: {
                        HStack {
                            Text("Publish")
                        }
                    }.disabled(!validationQuestion(questionBox: queryString, codeBlock: codeBlockString))
            )
            .tint(Color(selectedColor))
        }
        
        .onReceive(obj.$isQueryPosted) { isPostedStatus in
            if isPostedStatus {
                alertToggle.toggle()
            } else {
                //TODO: Throw Alert
            }
        }
        
        .alert(isPresented: $alertToggle) {
            Alert(title: Text("Reply Posted Successfully"), dismissButton: .default(Text("Okay"), action: {
                dismissButton.wrappedValue.dismiss()
            }))
        }
    }
    
    func validationQuestion(questionBox: String, codeBlock: String) -> Bool {
        if questionBox.count >= 1 && questionBox.count <= 500 && !(questionBox.hasPrefix(" ") && questionBox.hasSuffix(" ")) &&  (codeBlock.count == 0 || (codeBlock.count >= 1 && codeBlock.count <= 500 && !(codeBlock.hasPrefix(" ") && codeBlock.hasSuffix(" ")))){
            return true
        }
        return false
    }
    
}

extension ReplyTOQuestionView {
    var postQuestionTextFieldForReply: some  View {
        VStack {
            HStack(alignment: .center){
                Text("Reply Block")
                    .font(.callout)
                    .fontWeight(.medium)
                
                Text("(\(queryString.count)/500)")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .fontWeight(.thin)
                
                Spacer()
            }
            .padding(.horizontal, 15)
            .padding(.top, 10)
            
            TextEditor(text: $queryString)
                .frame(width: UIScreen.main.bounds.width/1.2, height: UIScreen.main.bounds.width/1.7)
                .scrollContentBackground(.hidden)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
                .scrollDismissesKeyboard(ScrollDismissesKeyboardMode.immediately)
                .keyboardType(.default)
                .tint(Color(selectedColor))
        }
        .padding(.bottom, 30)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(15)
    }
}

extension ReplyTOQuestionView {
    var codeBlockTextFieldForReply: some View {
        VStack {
            HStack(alignment: .center){
                Text("Code Block")
                    .font(.callout)
                    .fontWeight(.medium)
                
                Text("\(codeBlockString.count)/500  Optional")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .fontWeight(.thin)
                
                Spacer()
            }
            .padding(.horizontal, 15)
            .padding(.top, 10)
            
            if #available(iOS 16.1, *) {
                TextEditor(text: $codeBlockString)
                    .frame(width: UIScreen.main.bounds.width/1.2, height: UIScreen.main.bounds.width/1.7)
                    .fontDesign(.monospaced)
                    .scrollContentBackground(.hidden)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(10)
                    .scrollDismissesKeyboard(ScrollDismissesKeyboardMode.immediately)
                    .tint(Color(selectedColor))
            } else {
                TextEditor(text: $codeBlockString)
                    .frame(width: UIScreen.main.bounds.width/1.2, height: UIScreen.main.bounds.width/1.7)
                    .scrollContentBackground(.hidden)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(10)
                    .scrollDismissesKeyboard(ScrollDismissesKeyboardMode.immediately)
                    .tint(Color(selectedColor))
            }
            
        }
        .padding(.bottom, 30)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(15)
    }
}
