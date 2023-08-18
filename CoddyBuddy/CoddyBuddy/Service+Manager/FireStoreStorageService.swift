//  FireStoreStorageService.swift
//  Created by Aum Chauhan on 22/07/23.

import UIKit
import Foundation
import FirebaseStorage

/**
 Enumeration for selecting storage directory for images.
 
 - Case `profilePhotos` : Directory for user profile photos.
 - Case `chatRoomProfile` : Directory for chat room profile images.
 */
enum ImageStoragePath: String {
    case profilePhotos = "ProfilePhotos"
    case chatRoomProfile = "ChatRoomProfile"
}

actor FireStoreStorageService {
    
    /// - Uploads Images TO FireStorage And Returns Image URL.
    func setImageToFirestore(image: UIImage, path: ImageStoragePath) async throws -> String? {
        var photoRef: StorageReference
        
        // Storage Type
        StorageMetadata().contentType = "image/jpeg"
        
        // Image Compression
        guard let profilePhotoImgData = image.jpegData(compressionQuality: 0.0015) else { return "" }
        
        let imgFileName: String = UUID().uuidString
        
        if path == .chatRoomProfile {
            // ChatRooms Photos
            photoRef = Storage.storage().reference(withPath: "/ChatRoomProfile/\(imgFileName).jpeg")
        } else if path == .profilePhotos {
            // User Profile Photos
            photoRef = Storage.storage().reference(withPath: "/ProfilePhotos/\(imgFileName).jpeg")
        } else {
            // Default
            photoRef = Storage.storage().reference(withPath: "/ProfilePhotos/\(imgFileName).jpeg")
        }
        
        // PUT REQUEST
        let imagePath = try await photoRef.putDataAsync(profilePhotoImgData)
        print(imagePath)
        
        // GET REQUEST
        return try await photoRef.downloadURL().absoluteString
    }
}

