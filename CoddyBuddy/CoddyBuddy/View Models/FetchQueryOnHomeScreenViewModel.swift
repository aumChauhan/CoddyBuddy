import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class FetchUserQueriesOn_HomeTab_ViewModel: ObservableObject {
    
    @Published var fetchedQueryDataArray : [PostedQuery_MetaData] = []
    var objPostModelSync = PostQuestionDataModel_Sync()
    let obj_UserService = fetchUserServiceViewModel()
    
    init() {
        fetchUserQuieries()
    }
    
    func fetchUserQuieries() {
        objPostModelSync.postQuery { posts in
            self.fetchedQueryDataArray = posts
            
            for index in 0 ..< posts.count {
                let uid = posts[index].uid
                
                self.obj_UserService.fetchUserData(withuid: uid) { user in
                    self.fetchedQueryDataArray[index].user = user
                }
            }
        }
    }
}
