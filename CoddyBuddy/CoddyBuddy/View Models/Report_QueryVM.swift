import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

struct SubmitReport_Struct {
    func submitReport_TO_DB(
        reportedPost_Content: String,
        reportedPost_CodeBlock: String,
        who_Reported_Name: String,
        reportedPost_ID: String,
        isUploadedSuccessfully: @escaping(Bool) -> Void) {
            
            guard let userUID = Auth.auth().currentUser?.uid else { return }
            
            let QueryPostDataDictionary = [
                "Reporter_UserId": userUID,
                "Reporter_Name": who_Reported_Name,
                "ReportedQuery_Content": reportedPost_Content,
                "ReportedQuery_CodeBlock": reportedPost_CodeBlock,
                "Reported_QueryID": reportedPost_ID
            ] as [String: Any]
            
            DispatchQueue.global(qos: .background).async {
                Firestore.firestore().collection("Reported_Queries").document()
                    .setData(QueryPostDataDictionary) { error in
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

class SubmitReportVM: ObservableObject {
    
    let ofor = SubmitReport_Struct()
    @Published var isReported: Bool = false
    
    func reportF(
        reportedPost_Content: String,
        reportedPost_CodeBlock: String,
        who_Reported_Name: String, reportedPost_ID: String) {
            ofor.submitReport_TO_DB(reportedPost_Content: reportedPost_Content, reportedPost_CodeBlock: reportedPost_CodeBlock, who_Reported_Name: who_Reported_Name, reportedPost_ID: reportedPost_ID) { isReported in
                if isReported {
                    withAnimation {
                        self.isReported = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                self.isReported.toggle()
                            }
                        }
                    }
                } else {
                    // TODO: THROW ALERT
                }
            }
        }
}
