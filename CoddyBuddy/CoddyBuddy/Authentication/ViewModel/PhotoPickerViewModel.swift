//  PhotoPickerNativeViewModel.swift
//  Created by Aum Chauhan on 22/07/23.

import Foundation
import SwiftUI
import PhotosUI

@MainActor
class PhotoPickerViewModel: ObservableObject {
    
    let service = FireStoreStorageService()
    
    @Published var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    withAnimation {
                        selectedImage = uiImage
                    }
                    return
                }
            }
        }
    }
}
