import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct UploadImageToDataBase {
    
    static func uploadProfile(image: UIImage, compleationHandler: @escaping(String) -> Void) {
        
        guard let profileImageData = image.jpegData(compressionQuality: 0.1) else { return }
        let imageFileName = NSUUID().uuidString
        let referenceToPath = Storage.storage().reference(withPath: "/userProfile_Images/\(imageFileName)")
        
        referenceToPath.putData(profileImageData) { _, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            
            referenceToPath.downloadURL { imageURL, _ in
                guard let imageURL = imageURL?.absoluteString else { return }
                compleationHandler(imageURL)
            }
        }
    }
}
