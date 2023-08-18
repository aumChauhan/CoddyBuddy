//  FileManagerService.swift
//  Created by Aum Chauhan on 22/07/23.

import Foundation
import SwiftUI

class FileManagerService {
    // CachedData Directory Name
    private let directory = "CoddyBuddyCacheData"
    
    init() {
        createFolderIfNeeded()
    }
    
    /// - Creates Directory Into User Device.
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
    
    /// - Gets Cache Directory Folder Paths.
    func getFolderPath() -> URL? {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(directory)
    }
    
    /// - Gets Image Path From Cache Directory.
    private func getImagePath(key: String) -> URL? {
        guard let directory = getFolderPath() else { return nil }
        
        return directory.appendingPathComponent(key + ".jpeg")
    }
    
    /// - Appends Images To Cache Directory.
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
    
    /// - Retrieves Images From Cache Directory.
    func get(key: String) -> UIImage? {
        guard
            let url = getImagePath(key: key),
            FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
}
