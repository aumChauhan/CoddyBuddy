import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class Question_Feed_SingleRow_ViewModel: ObservableObject {
    let instancePostSync = PostQuestionDataModel_Sync()
    @Published var postedQuestion: PostedQuery_MetaData
    
    init (questionPost: PostedQuery_MetaData) {
        self.postedQuestion = questionPost
        isLiked()
    }
    
    func likePost() {
        instancePostSync.likePost(postedQuestion) {
            self.postedQuestion.isLiked = true
        }
    }
    func returnLikesCount() -> Int {
        return self.postedQuestion.likes
    }
    
    func dislikePost() {
        instancePostSync.dissLikePost(postedQuestion) {
            self.postedQuestion.isLiked = false
        }
    }
    
    func isLiked() {
        instancePostSync.isLiked(postedQuestion) { didLike in
            if didLike {
                self.postedQuestion.isLiked = true
            }
        }
    }
}

