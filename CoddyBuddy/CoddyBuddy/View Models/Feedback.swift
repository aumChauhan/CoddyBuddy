import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

struct shareFeedback_Struct {
    func uploadFeedback(feedbackType: String, feedbackString: String, isUploadedSuccessfully: @escaping(Bool) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let feedbackDataDictionary = [
            "UserId": userUID,
            "FeedbackType": feedbackType,
            "Feedback": feedbackString,
            "FeedbackSubmitedOn": Timestamp(date: Date())
        ] as [String: Any]
        
        DispatchQueue.global(qos: .background).async {
            Firestore.firestore().collection("Feedback").document()
                .setData(feedbackDataDictionary) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        isUploadedSuccessfully(false)
                        return
                    } else {
                        isUploadedSuccessfully(true)
                    }
                }
        }
    }
}

class feedbackViewModel: ObservableObject {
    
    let feedbackStructObj = shareFeedback_Struct()
    @Published var isSubmitted: Bool = false
    
    func postFeedback(feedbackType: String, feedbackString: String) {
        feedbackStructObj.uploadFeedback(feedbackType: feedbackType, feedbackString: feedbackString) { posted in
            if posted {
                self.isSubmitted = true
            } else {
                // TODO: Exception Handling
            }
        }
    }
}

