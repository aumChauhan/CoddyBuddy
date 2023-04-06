import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class Fetch_RepliesViewModel: ObservableObject{
    
    @Published var fetchedReplyDataArray = [Reply_MetaData]()
    var objPostModelSync = UploadReply()
    let obj_UserService = fetchUserServiceViewModel()
    @Published var postedQuestion: PostedQuery_MetaData
    
    init(questionPost: PostedQuery_MetaData) {
        self.postedQuestion = questionPost
        self.fetchUserReply()
    }
    
    func fetchUserReply() {
        objPostModelSync.postReply_data(postedQuestion) {[weak self] posts in
            self?.fetchedReplyDataArray = posts
            
            for index in 0 ..< posts.count {
                let uid = posts[index].uid
                
                self?.obj_UserService.fetchUserData(withuid: uid) { user in
                    self?.fetchedReplyDataArray[index].user = user
                }
            }
            
        }
    }
}
