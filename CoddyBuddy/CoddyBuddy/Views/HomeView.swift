import SwiftUI
import AVKit
import Foundation
import FirebaseCore
import FirebaseFirestore

struct HomeView: View {
    
    let link = URL(string: "https://www.coddybuddy.com")!
    let columnss: [GridItem] = [ GridItem(.fixed(UIScreen.main.bounds.width)) ]
    let pasteboard = UIPasteboard.general
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    @AppStorage("chatBotIcon") var chatBotIcon: String = "bot"
    @State var chatBotSheetToogle: Bool = false
    
    @State var toggle_NewPostSheet: Bool = false
    @State var optionSheet_Toggle: Bool = false
    @State var reloadData: Bool = false
    @State private var disableDrag = false
    @State private var tabButtonFlag = 1
    @State var toogleActionSheetForLogOut: Bool = false
    @State var deletePost: Bool = true
    @AppStorage("toggleChatBot") var toggleChatBot: Bool = true
    
    @ObservedObject var Fetching_Object = FetchUserQueriesOn_HomeTab_ViewModel()
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @ObservedObject var PostQueryViewModel_Object = PostQueryViewModel()
    @AppStorage("toggleLocalNotifications") var toggleLocalNotifications: Bool = true
    @ObservedObject var Obj = SubmitReportVM()
    
    var body: some View {
        NavigationView {
            if AuthenticationObject.currentUserData != nil {
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        if tabButtonFlag == 1 {
                            ForEach(Fetching_Object.fetchedQueryDataArray.sorted(by: { $0.QueryPostedOn.compare($1.QueryPostedOn) == .orderedDescending })) { index in
                                LazyVGrid(columns: columnss) {
                                    Question_Post_View(questionPost: index, reloadDataBind: $reloadData)
                                }
                            }
                        }
                        else if tabButtonFlag == 2  {
                            ForEach(Fetching_Object.fetchedQueryDataArray.sorted(by: { $0.QueryPostedOn.compare($1.QueryPostedOn) == .orderedAscending })) { index in
                                LazyVGrid(columns: columnss) {
                                    Question_Post_View(questionPost: index, reloadDataBind: $reloadData)
                                }
                            }
                        }
                    }
                    .refreshable {Fetching_Object.fetchUserQuieries()}
                    
                    if PostQueryViewModel_Object.isQueryPosted {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Query Posted Successfully")
                                .fontWeight(.bold)
                        }
                        .padding(6)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(.green)
                        .cornerRadius(20)
                        .padding(.horizontal, 15)
                    } else {
                        HStack{
                            Spacer()
                            Button {
                                withAnimation {
                                    toggle_NewPostSheet.toggle()
                                    if toggleHaptics {
                                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                    }
                                }
                            } label: {
                                Image(systemName: "pencil.line")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .scaleEffect(1.8)
                                    .frame(width: 55, height: 55)
                                    .background(Color(selectedColor))
                                    .cornerRadius(15)
                                    .frame(width: 50, height: 50)
                                    .padding(17)
                                    .padding(.bottom, 5)
                            }
                        }
                    }
                }
                
                .navigationTitle("Home")
                .navigationBarItems(
                    trailing:
                        HStack {
                            if !toggleChatBot {
                                Button {
                                    chatBotSheetToogle.toggle()
                                } label: {
                                    Image(chatBotIcon)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 21, height: 21)
                                        .foregroundColor(Color(selectedColor))
                                }
                                
                            }
                            
                            Menu(content: {
                                Button {
                                    withAnimation {
                                        Fetching_Object.fetchUserQuieries()
                                        if toggleHaptics {
                                            UINotificationFeedbackGenerator().notificationOccurred(.error)
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text("Reload")
                                        Spacer()
                                        Image(systemName: "arrow.triangle.2.circlepath")
                                    }
                                }
                                
                                Menu {
                                    Button {
                                        withAnimation {
                                            tabButtonFlag = 1
                                            if toggleHaptics {
                                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                            }
                                        }
                                    } label: {
                                        Text("Newest First")
                                    }
                                    
                                    Button {
                                        withAnimation {
                                            tabButtonFlag = 2
                                            if toggleHaptics {
                                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                            }
                                        }
                                    } label: {
                                        Text("Oldest First")
                                    }
                                    
                                } label: {
                                    HStack {
                                        Text("Filter")
                                        Spacer()
                                        Image(systemName: "arrow.up.arrow.down")
                                    }
                                }
                                
                                Divider()
                                
                                Button(role: .destructive) {
                                    toogleActionSheetForLogOut.toggle()
                                    if toggleHaptics {
                                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                    }
                                } label: {
                                    HStack {
                                        Text("Sign Out")
                                            .foregroundColor(.red)
                                        Spacer()
                                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                                            .foregroundColor(.red)
                                    }
                                }
                            }, label: {
                                Image(systemName: "ellipsis.circle")
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                                    .foregroundColor(Color(selectedColor))
                            }
                            )
                        }
                )
                
            }
            else { withAnimation { LoadingScreen() } }
        }
        .navigationViewStyle(.stack)
        
        
        .confirmationDialog("Log Out", isPresented: $toogleActionSheetForLogOut, actions: {
            Button(role: .destructive) {
                withAnimation {
                    AuthenticationObject.logOut()
                    selectedColor = "Theme_Blue"
                    if toggleHaptics {
                        UINotificationFeedbackGenerator().notificationOccurred(.warning)
                    }
                }
            } label: {
                Text("Log Out")
            }
            
            Button("Cancel", role: .cancel) {
                if toggleHaptics {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
            }
        })
        
        .sheet(isPresented: $chatBotSheetToogle, content: {
            AskBotView()
        })
        .sheet(
            isPresented: $toggle_NewPostSheet,
            onDismiss: { Fetching_Object.fetchUserQuieries() }) {
                PostQuestionView()
                    .interactiveDismissDisabled(true)
            }
            .interactiveDismissDisabled(true)
        
            .alert(isPresented: $Obj.isReported) {
                Alert(title: Text("Thanks For Reporting"), message: Text("Description for successfully reported the post"), dismissButton: .cancel())
            }
    }
}

struct Question_Post_View: View {
    
    let link = URL(string: "https://www.coddybuddy.com")!
    let pasteboard = UIPasteboard.general
    
    @Binding var reloadData: Bool
    
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("toggleDarkModeCodeBlock") var toggleDarkModeCodeBlock: Bool = false
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    @AppStorage("playSoundOnCopied") var playSoundOnCopied: Bool = true
    
    @State var messageCopiedNotifications: Bool = false
    @State var question: String = ""
    @State var code: String = ""
    @State var sheetToggle: Bool = true
    @State var deleteToogle: Bool = false
    @State var likesCount: Int = 0
    @State var shareSheetTooogle: Bool = false
    @ObservedObject var Fetching_Object = FetchUserQueriesOn_HomeTab_ViewModel()
    @ObservedObject var ViewModel_Question_Feed_Row: Question_Feed_SingleRow_ViewModel
    @ObservedObject var fetchReplies: Fetch_RepliesViewModel
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @ObservedObject var PostQueryObject: PostQueryViewModel = PostQueryViewModel()
    @ObservedObject var Obj = SubmitReportVM()
    
    init(questionPost: PostedQuery_MetaData, reloadDataBind: Binding<Bool>) {
        self.ViewModel_Question_Feed_Row = Question_Feed_SingleRow_ViewModel(questionPost: questionPost)
        self.fetchReplies = Fetch_RepliesViewModel(questionPost: questionPost)
        self._reloadData = reloadDataBind
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .leading) {
                if Obj.isReported {
                    VStack(spacing: 8) {
                        LottieAnimationViews(fileName: "103379-success-alert")
                            .frame(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
                        
                        Text("Thanks For Reporting")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text("Your Feedback is important in helping us keep the CoddyBuddy community safe.")
                            .multilineTextAlignment(.center)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 15)
                }
                else {
                    HStack(alignment: .top, spacing: 12) {
                        if ViewModel_Question_Feed_Row.postedQuestion.user?.showProfilePic ?? false {
                            OnlyProfilePhotoView(url: ViewModel_Question_Feed_Row.postedQuestion.user?.profilePicURL ?? "", key: ViewModel_Question_Feed_Row.postedQuestion.user?.id ?? "")
                            
                        } else {
                            RoundedRectangle(cornerRadius: 11)
                                .fill((LinearGradient(colors: [Color(ViewModel_Question_Feed_Row.postedQuestion.user?.randomColorProfile ?? ""), Color(ViewModel_Question_Feed_Row.postedQuestion.user?.randomColorProfile ?? "").opacity(0.7)], startPoint: .top, endPoint: .bottom)))
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
                            HStack(alignment: .top, spacing: 0) {
                                HStack(alignment: .center, spacing: 3) {
                                    Text(ViewModel_Question_Feed_Row.postedQuestion.user?.anonymousName ?? false ? "Anonymous": ViewModel_Question_Feed_Row.postedQuestion.user?.fullName ?? "")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    
                                    Image(systemName: ViewModel_Question_Feed_Row.postedQuestion.user?.isVerfied ?? false ? "checkmark.seal.fill" : "")
                                        .foregroundColor(.teal)
                                        .font(.caption)
                                    
                                    Spacer()
                                    HStack {
                                        Menu {
                                            ShareLink(
                                                "Share",
                                                item:"Question :\n\(ViewModel_Question_Feed_Row.postedQuestion.query)\n\nCodeBlock :\n\(ViewModel_Question_Feed_Row.postedQuestion.codeBlock)\n\n\(link)"
                                            ).onTapGesture {
                                                if toggleHaptics {
                                                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                                }
                                            }
                                            
                                            Button {
                                                pasteboard.string = "Question :\n\(ViewModel_Question_Feed_Row.postedQuestion.query)\n\nCodeBlock :\n\(ViewModel_Question_Feed_Row.postedQuestion.codeBlock)"
                                                
                                                withAnimation {
                                                    messageCopiedNotifications = true
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                    withAnimation {
                                                        messageCopiedNotifications = false
                                                    }
                                                }
                                                if playSoundOnCopied {
                                                    SoundPlayer.playSound()
                                                }
                                                if toggleHaptics {
                                                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                                }
                                            } label: {
                                                HStack {
                                                    Text("Copy")
                                                    Image(systemName: "doc.on.doc")
                                                }.foregroundColor(.red)
                                            }
                                            
                                            Divider()
                                            if !(ViewModel_Question_Feed_Row.postedQuestion.user?.id ?? "" == AuthenticationObject.currentUserData?.id){
                                                Button(role: .destructive) {
                                                    Obj.reportF(reportedPost_Content: ViewModel_Question_Feed_Row.postedQuestion.query, reportedPost_CodeBlock: ViewModel_Question_Feed_Row.postedQuestion.codeBlock, who_Reported_Name: AuthenticationObject.currentUserData?.fullName ?? "", reportedPost_ID: ViewModel_Question_Feed_Row.postedQuestion.id ?? "")
                                                    if toggleHaptics {
                                                        UINotificationFeedbackGenerator().notificationOccurred(.warning)
                                                    }
                                                } label: {
                                                    HStack {
                                                        Text("Report")
                                                        Image(systemName: "exclamationmark.triangle")
                                                    }.foregroundColor(.red)
                                                }
                                            }
                                            
                                            if (ViewModel_Question_Feed_Row.postedQuestion.user?.id ?? "" == AuthenticationObject.currentUserData?.id) {
                                                Button(role: .destructive) {
                                                    if toggleHaptics {
                                                        UINotificationFeedbackGenerator().notificationOccurred(.warning)
                                                    }
                                                    withAnimation {
                                                        deleteToogle.toggle()
                                                    }
                                                } label: {
                                                    HStack {
                                                        Text("Delete")
                                                        Image(systemName: "trash")
                                                    }.foregroundColor(.red)
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
                                Text("@\(ViewModel_Question_Feed_Row.postedQuestion.user?.anonymousUserName ?? false ? String("anonymous_"+(ViewModel_Question_Feed_Row.postedQuestion.user?.id?.prefix(5) ?? "")) : ViewModel_Question_Feed_Row.postedQuestion.user?.userName ?? "")")
                                    .font(.caption)
                                    .fontWeight(.thin)
                                    .foregroundColor(.primary)
                                
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 3))
                                    .foregroundColor(.gray)
                                    .opacity(0.8)
                                
                                Text(ViewModel_Question_Feed_Row.postedQuestion.QueryPostedOn.dateValue().formatted(date: .numeric, time: .omitted))
                                    .font(.caption)
                                    .fontWeight(.thin)
                                    .opacity(0.7)
                            }
                            
                            VStack(spacing: 0) {
                                NavigationLink {
                                    ReplyView(questionPost: ViewModel_Question_Feed_Row.postedQuestion)
                                } label: {
                                    VStack(alignment: .leading, spacing: 0){
                                        HStack{
                                            if ViewModel_Question_Feed_Row.postedQuestion.codeBlock.count >= 1 {
                                                Text("\(ViewModel_Question_Feed_Row.postedQuestion.query)")
                                                    .textSelection(.enabled)
                                                    .font(.system(size: 13.5))
                                                    .padding(.bottom, 5)
                                                    .multilineTextAlignment(.leading)
                                                Spacer()
                                            } else {
                                                Text("\(ViewModel_Question_Feed_Row.postedQuestion.query)")
                                                    .textSelection(.enabled)
                                                    .font(.system(size: 13.5))
                                                    .padding(.bottom, 5)
                                                    .multilineTextAlignment(.leading)
                                                Spacer()
                                            }
                                        }
                                        if ViewModel_Question_Feed_Row.postedQuestion.codeBlock.count >= 1 {
                                            if #available(iOS 16.1, *) {
                                                Text(ViewModel_Question_Feed_Row.postedQuestion.codeBlock)
                                                    .textSelection(.enabled)
                                                    .fontDesign(.monospaced)
                                                    .multilineTextAlignment(.leading)
                                                    .font(.system(size: 12))
                                                    .padding(7)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .background(Color(uiColor: .tertiarySystemBackground))
                                                    .cornerRadius(8)
                                                    .padding(.bottom, 5)
                                            } else {
                                                Text(ViewModel_Question_Feed_Row.postedQuestion.codeBlock)
                                                    .font(.system(size: 12))
                                                    .textSelection(.enabled)
                                                    .fontWeight(.medium)
                                                    .multilineTextAlignment(.leading)
                                                    .padding(7)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .background(Color(uiColor: .tertiarySystemBackground))
                                                    .cornerRadius(8)
                                                    .padding(.bottom, 5)
                                            }
                                        }
                                    }
                                    .padding(.top, 5)
                                }
                                
                                HStack(spacing: 5) {
                                    
                                    if !messageCopiedNotifications {
                                        Button {
                                            withAnimation {
                                                ViewModel_Question_Feed_Row.postedQuestion.isLiked ?? false ? ViewModel_Question_Feed_Row.dislikePost() : ViewModel_Question_Feed_Row.likePost()
                                            }
                                            
                                            if toggleHaptics {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            }
                                            
                                        } label: {
                                            HStack(spacing: 3) {
                                                Image(systemName: ViewModel_Question_Feed_Row.postedQuestion.isLiked ?? false ? "hand.thumbsup.fill" : "hand.thumbsup")
                                                    .foregroundColor(ViewModel_Question_Feed_Row.postedQuestion.isLiked ?? false ? Color(selectedColor)
                                                                     : .gray )
                                                    .font(.system(size: 13))
                                                Text("\(ViewModel_Question_Feed_Row.postedQuestion.likes)")
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 13))
                                            }
                                            .padding(.leading, 5)
                                        }
                                    }
                                    
                                    if !messageCopiedNotifications {
                                        Spacer()
                                        NavigationLink {
                                            ReplyView(questionPost: ViewModel_Question_Feed_Row.postedQuestion)
                                        } label: {
                                            HStack(spacing: 3) {
                                                Image(systemName: "message")
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 13))
                                                Text("\(fetchReplies.fetchedReplyDataArray.count)")
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 13))
                                            }
                                        }
                                    }
                                    
                                    if !messageCopiedNotifications {
                                        Spacer()
                                        ShareLink(
                                            "",
                                            item:"Question :\n\(ViewModel_Question_Feed_Row.postedQuestion.query)\n\nCodeBlock :\n\(ViewModel_Question_Feed_Row.postedQuestion.codeBlock)\n\n\(link)"
                                        )
                                        .foregroundColor(.gray)
                                        .font(.system(size: 13.5))
                                        .onTapGesture {
                                            if toggleHaptics {
                                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                            }
                                        }
                                    }
                                    
                                    if !messageCopiedNotifications {
                                        Spacer()
                                    }
                                    Button {
                                        pasteboard.string = "Question :\n\(ViewModel_Question_Feed_Row.postedQuestion.query)\n\nCodeBlock :\n\(ViewModel_Question_Feed_Row.postedQuestion.codeBlock)"
                                        withAnimation {
                                            messageCopiedNotifications = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            withAnimation {
                                                messageCopiedNotifications = false
                                            }
                                        }
                                        if playSoundOnCopied {
                                            SoundPlayer.playSound()
                                        }
                                        if toggleHaptics {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        }
                                        
                                    } label: {
                                        HStack {
                                            if messageCopiedNotifications {
                                                HStack(spacing: 5) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(.green)
                                                        .font(.system(size: 12))
                                                    
                                                    Text("Message copied to clipboard")
                                                }
                                                .frame(maxWidth: .infinity)
                                                .padding(5)
                                                .font(.system(size: 12))
                                                .foregroundColor(.primary)
                                                .background(Color(uiColor: .tertiarySystemBackground))
                                                .cornerRadius(20)
                                                
                                            } else {
                                                Image(systemName: "doc.on.doc")
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 13))
                                            }
                                            
                                        }
                                        .padding(.trailing, 5)
                                    }
                                }
                                .padding(.top, 3)
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
            }
            .padding(12)
            .background(Color.init(uiColor: .secondarySystemBackground))
            .cornerRadius(15)
            .padding(.horizontal,14)
            .padding(.vertical, 2)
        }
        
        .alert(isPresented: $deleteToogle) {
            Alert(title: Text("Delete Query"), message: Text("You will not be able to recover this query again"), primaryButton: .default(Text("Cancel")), secondaryButton: .destructive(Text("Delete"), action: {
                PostQueryObject.deleteQuery(Post: ViewModel_Question_Feed_Row.postedQuestion)
            }))
        }
    }
}

struct Question_Post_View_IN_Reply: View {
    
    let link = URL(string: "https://www.coddybuddy.com")!
    let pasteboard = UIPasteboard.general
    
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    @AppStorage("playSoundOnCopied") var playSoundOnCopied: Bool = true
    @State var messageCopiedNotifications: Bool = false
    
    @State var question: String = ""
    @State var code: String = ""
    @State var sheetToggle: Bool = true
    @ObservedObject var Fetching_Object = FetchUserQueriesOn_HomeTab_ViewModel()
    @ObservedObject var ViewModel_Question_Feed_Row: Question_Feed_SingleRow_ViewModel
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @ObservedObject var fetchReplies: Fetch_RepliesViewModel
    @ObservedObject var Obj = SubmitReportVM()
    
    init(questionPost: PostedQuery_MetaData) {
        self.ViewModel_Question_Feed_Row = Question_Feed_SingleRow_ViewModel(questionPost: questionPost)
        self.fetchReplies = Fetch_RepliesViewModel(questionPost: questionPost)
    }
    
    var body: some View {
        if Obj.isReported {
            VStack(spacing: 8) {
                LottieAnimationViews(fileName: "103379-success-alert")
                    .frame(width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9)
                
                Text("Thanks For Reporting")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("Your Feedback is important in helping us keep the CoddyBuddy community safe.")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(15)
            .padding(.horizontal, 15)
            
        }
        else {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 12) {
                    if ViewModel_Question_Feed_Row.postedQuestion.user?.showProfilePic ?? false {
                        OnlyProfilePhotoView(url: ViewModel_Question_Feed_Row.postedQuestion.user?.profilePicURL ?? "", key: ViewModel_Question_Feed_Row.postedQuestion.user?.id ?? "")
                    } else {
                        RoundedRectangle(cornerRadius: 11)
                            .fill((LinearGradient(colors: [Color(ViewModel_Question_Feed_Row.postedQuestion.user?.randomColorProfile ?? ""), Color(ViewModel_Question_Feed_Row.postedQuestion.user?.randomColorProfile ?? "").opacity(0.7)], startPoint: .top, endPoint: .bottom)))
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
                        HStack(alignment: .top, spacing: 0) {
                            HStack(alignment: .center,spacing: 3) {
                                Text(ViewModel_Question_Feed_Row.postedQuestion.user?.anonymousName ?? false ? "Anonymous": ViewModel_Question_Feed_Row.postedQuestion.user?.fullName ?? "")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                Image(systemName: ViewModel_Question_Feed_Row.postedQuestion.user?.isVerfied ?? false ? "checkmark.seal.fill" : "")
                                    .foregroundColor(.teal)
                                    .font(.caption)
                                
                                Spacer()
                                
                                HStack {
                                    Menu {
                                        ShareLink(
                                            "Share",
                                            item:"Question :\n\(ViewModel_Question_Feed_Row.postedQuestion.query)\n\nCodeBlock :\n\(ViewModel_Question_Feed_Row.postedQuestion.codeBlock)\n\n\(link)"
                                        )
                                        .onTapGesture {
                                            if toggleHaptics {
                                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                            }
                                        }
                                        Button {
                                            pasteboard.string = "Question :\n\(ViewModel_Question_Feed_Row.postedQuestion.query)\n\nCodeBlock :\n\(ViewModel_Question_Feed_Row.postedQuestion.codeBlock)"
                                            if toggleHaptics {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            }
                                            withAnimation {
                                                messageCopiedNotifications = true
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                withAnimation {
                                                    messageCopiedNotifications = false
                                                }
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
                                        
                                        Divider()

                                        if !(ViewModel_Question_Feed_Row.postedQuestion.user?.id ?? "" == AuthenticationObject.currentUserData?.id) {
                                            Button(role: .destructive) {
                                                Obj.reportF(reportedPost_Content: ViewModel_Question_Feed_Row.postedQuestion.query, reportedPost_CodeBlock: ViewModel_Question_Feed_Row.postedQuestion.codeBlock, who_Reported_Name: AuthenticationObject.currentUserData?.fullName ?? "", reportedPost_ID: ViewModel_Question_Feed_Row.postedQuestion.id ?? "")
                                                if toggleHaptics {
                                                    UINotificationFeedbackGenerator().notificationOccurred(.warning)
                                                }
                                            } label: {
                                                HStack {
                                                    Text("Report")
                                                    Image(systemName: "exclamationmark.triangle")
                                                }.foregroundColor(.red)
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
                            Text("@\(ViewModel_Question_Feed_Row.postedQuestion.user?.anonymousUserName ?? false ? String("anonymous_"+(ViewModel_Question_Feed_Row.postedQuestion.user?.id?.prefix(5) ?? "")) : ViewModel_Question_Feed_Row.postedQuestion.user?.userName ?? "")")
                                .font(.caption)
                                .fontWeight(.thin)
                                .foregroundColor(.primary)
                            
                            Image(systemName: "circle.fill")
                                .font(.system(size: 3))
                                .foregroundColor(.gray)
                                .opacity(0.8)
                            
                            Text(ViewModel_Question_Feed_Row.postedQuestion.QueryPostedOn.dateValue().formatted(date: .numeric, time: .omitted))
                                .font(.caption)
                                .fontWeight(.thin)
                                .opacity(0.7)
                        }
                       
                        VStack(alignment: .leading, spacing: 0){
                            Text(ViewModel_Question_Feed_Row.postedQuestion.query)
                                .textSelection(.enabled)
                                .font(.system(size: 13.5))
                                .padding(.bottom, 7)
                                .padding(.top, 2)
                            
                            if ViewModel_Question_Feed_Row.postedQuestion.codeBlock.count >= 1 {
                                if #available(iOS 16.1, *) {
                                    Text(ViewModel_Question_Feed_Row.postedQuestion.codeBlock)
                                        .textSelection(.enabled)
                                        .fontDesign(.monospaced)
                                        .font(.system(size: 12))
                                        .padding(7)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(uiColor: .tertiarySystemBackground))
                                        .cornerRadius(8)
                                        .padding(.bottom, 5)
                                    
                                } else {
                                    Text(ViewModel_Question_Feed_Row.postedQuestion.codeBlock)
                                        .textSelection(.enabled)
                                        .fontWeight(.medium)
                                        .font(.system(size: 13.5))
                                        .padding(7)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(uiColor: .systemBackground))
                                        .cornerRadius(8)
                                        .padding(.bottom, 5)
                                    
                                }
                            }
                            
                            HStack(spacing: 5){
                                if !messageCopiedNotifications {
                                    Button {
                                        withAnimation {
                                            ViewModel_Question_Feed_Row.postedQuestion.isLiked ?? false ? ViewModel_Question_Feed_Row.dislikePost() : ViewModel_Question_Feed_Row.likePost()
                                        }
                                        if toggleHaptics {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        }
                                    } label: {
                                        HStack(spacing: 3) {
                                            Image(systemName: ViewModel_Question_Feed_Row.postedQuestion.isLiked ?? false ? "hand.thumbsup.fill" : "hand.thumbsup")
                                                .foregroundColor(ViewModel_Question_Feed_Row.postedQuestion.isLiked ?? false ? Color(selectedColor)
                                                                 : .gray )
                                                .font(.system(size: 13))
                                            Text("\(ViewModel_Question_Feed_Row.returnLikesCount())")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 13))
                                        }
                                        .padding(.leading, 5)
                                    }
                                }
                                
                                if !messageCopiedNotifications {
                                    Spacer()
                                    HStack(spacing: 3) {
                                        Image(systemName: "message")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 13))
                                        Text("\(fetchReplies.fetchedReplyDataArray.count)")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 13))
                                    }
                                }
                                
                                if !messageCopiedNotifications {
                                    Spacer()
                                    ShareLink(
                                        "",
                                        item:"Question :\n\(ViewModel_Question_Feed_Row.postedQuestion.query)\n\nCodeBlock :\n\(ViewModel_Question_Feed_Row.postedQuestion.codeBlock)\n\n\(link)"
                                    )
                                    .foregroundColor(.gray)
                                    .font(.system(size: 13.5))
                                    .onTapGesture {
                                        if toggleHaptics {
                                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                        }
                                    }
                                }
                                
                                if !messageCopiedNotifications {
                                    Spacer()
                                }
                                
                                Button {
                                    pasteboard.string = "Question :\n\(ViewModel_Question_Feed_Row.postedQuestion.query)\n\nCodeBlock :\n\(ViewModel_Question_Feed_Row.postedQuestion.codeBlock)"
                                    withAnimation {
                                        messageCopiedNotifications = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        withAnimation {
                                            messageCopiedNotifications = false
                                        }
                                    }
                                    if toggleHaptics {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    }
                                    if playSoundOnCopied {
                                        SoundPlayer.playSound()
                                    }
                                } label: {
                                    HStack {
                                        if messageCopiedNotifications {
                                            HStack(spacing: 5) {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.green)
                                                    .font(.system(size: 12))
                                                
                                                Text("Message copied to clipboard")
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(5)
                                            .font(.system(size: 12))
                                            .foregroundColor(.primary)
                                            .background(Color(uiColor: .tertiarySystemBackground))
                                            .cornerRadius(20)
                                            
                                        } else {
                                            Image(systemName: "doc.on.doc")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 13))
                                        }
                                    }
                                    .padding(.trailing, 5)
                                }
                            }
                            .padding(.top, 3)
                        }
                        .padding(.top, 5)
                    }
                }
            }
            .padding(12)
            .background(Color.init(uiColor: .secondarySystemBackground))
            .cornerRadius(15)
            .padding(.horizontal,14)
            .padding(.vertical, 2)
        }
    }
}


struct PostQuestionView: View {
    
    @State var queryString: String = ""
    @State var codeBlockString: String = ""
    
    @AppStorage("selectedColor") var selectedColor: String = "Theme_Blue"
    @AppStorage("toggleHaptics") var toggleHaptics: Bool = true
    
    @State var tabCategory: [String] = ["Question Block", "Code Block"]
    @State var tabSelected: String = "Question Block"
    @Namespace private var namepsace
    
    @Environment(\.presentationMode) var dismissButton
    @EnvironmentObject var AuthenticationObject: UserAuthnticateViewModel
    @ObservedObject var PostQueryViewModel_Object = PostQueryViewModel()
    
    @State var previewSheetToogle: Bool = false
    @State var alertSheetToogle: Bool = false
    @State var toggleOptionButton: Bool = false
    @State var tagItemForTabView: Int = 1
    
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
                            postQuestionTextField
                                .tag("Question Block")
                            
                            codeBlockTextField
                                .tag("Code Block")
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(width: UIScreen.main.bounds.width/1.1, height:  UIScreen.main.bounds.width/1.2)
                        .padding(.horizontal, 15)
                        .cornerRadius(15)
                        
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
                            withAnimation {
                                Text("\(index)")
                                    .fontWeight(tabSelected == index ? .semibold : .regular)
                                    .foregroundColor(tabSelected == index ? .white : .gray)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            tabSelected = index
                                        }
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
            
            .navigationTitle("Post Query")
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
                    }),
                trailing:
                    Button {
                        withAnimation {
                            PostQueryViewModel_Object.postQueryDB(withQuery: queryString.trimmingCharacters(in: .whitespacesAndNewlines), codeBlock: codeBlockString.trimmingCharacters(in: .whitespacesAndNewlines))
                            
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    } label: {
                        HStack {
                            Text("Publish")
                        }
                    }.disabled(!validationQuestion(questionBox: queryString, codeBlock: codeBlockString))
                    .tint(Color(selectedColor))
            )
        }
        
        .onReceive(PostQueryViewModel_Object.$isQueryPosted) { isPostedStatus in
            if isPostedStatus {
                alertSheetToogle.toggle()
            }
        }
        
        .alert(isPresented: $alertSheetToogle) {
            Alert(title: Text("Query Published Successfully"), dismissButton : .default(Text("Okay"), action: {
                withAnimation {
                    dismissButton.wrappedValue.dismiss()
                }
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

extension PostQuestionView {
    var postQuestionTextField: some  View {
        VStack {
            HStack(alignment: .center){
                Text("Post Question")
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

extension PostQuestionView {
    var codeBlockTextField: some View {
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
                    .fontDesign(.monospaced)
                    .frame(width: UIScreen.main.bounds.width/1.2, height: UIScreen.main.bounds.width/1.7)
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

class SoundPlayer{
    static var music: AVAudioPlayer?
    
    static func playSound() {
        
        if let AudioPathURL = Bundle.main.url(forResource: "copy", withExtension: ".mp3"){
            do {
                music = try AVAudioPlayer(contentsOf: AudioPathURL)
                music?.play()
            } catch let error {
                print("\(error.localizedDescription)")
            }
        }
    }
}

