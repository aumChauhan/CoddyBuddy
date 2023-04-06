import Foundation
import SwiftUI

class FileManagerNewsRoom {
    static let instance = FileManagerNewsRoom()
    let folderName = "CoddyBuddy_Cache_UserProfilesPhoto"
    
    private init() {
        createFolderIfNeeded()
    }
    
    func createFolderIfNeeded() {
        guard let url = getFolderPath() else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
                print("Folder Created")
            } catch let error {
                print(error)
            }
        }
    }
    
    func getFolderPath() -> URL? {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }
    
    private func getImagePath(key: String) -> URL? {
        guard let directory = getFolderPath() else { return nil }
        
        return directory.appendingPathComponent(key + ".png")
    }
    
    func add(key: String, image: UIImage) {
        guard
            let data = image.pngData(),
            let url = getImagePath(key: key) else {return}
        
        do {
            try data.write(to: url)
        } catch let error {
            print("Error Saving Image\(error)")
        }
    }
    
    func get(key: String) -> UIImage? {
        guard
            let url = getImagePath(key: key),
            FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
}

