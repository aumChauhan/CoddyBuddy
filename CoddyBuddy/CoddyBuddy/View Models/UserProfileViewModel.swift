import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class ProfileViewModel: ObservableObject {
    
    @Published var userPosts = [PostedQuery_MetaData]()
    @Published var userLikedPosts = [PostedQuery_MetaData]()
    @Published var userReplies = [Reply_MetaData]()
    
    var objPostModelSync = PostQuestionDataModel_Sync()
    var objReplyModelSync = UploadReply()
    let obj_UserService = fetchUserServiceViewModel()
    let userInfo: RegisteredUserDataModel
    
    init(userInfo: RegisteredUserDataModel) {
        self.userInfo = userInfo
        self.fetchUserOwnPosts()
        self.fetchLikedQuestion()
    }
    
    func fetchUserOwnPosts() {
        objPostModelSync.fetchPostQuery_UserProfile(forUUID: userInfo.id ?? "") { postsUsers in
            self.userPosts = postsUsers
            
            for index in 0 ..< postsUsers.count {
                self.userPosts[index].user = self.userInfo
            }
        }
    }
    
    func fetchRepliedQuestion() {
        objReplyModelSync.fetchPostReply_UserProfile(forUUID: userInfo.id ?? "") { repliesUsers in
            self.userReplies = repliesUsers
            
            for index in 0 ..< repliesUsers.count {
                self.userPosts[index].user = self.userInfo
            }
        }
    }
    
    func fetchLikedQuestion() {
        guard let uid = userInfo.id else { return }
        objPostModelSync.fetchLikedQuestion_UserProfile(forUID: uid) { posts in
            self.userLikedPosts = posts

            for index in 0 ..< posts.count {
                let uid = posts[index].uid
                
                self.obj_UserService.fetchUserData(withuid: uid) { user in
                    self.userLikedPosts[index].user = user
                }
            }
        }
    }
}
