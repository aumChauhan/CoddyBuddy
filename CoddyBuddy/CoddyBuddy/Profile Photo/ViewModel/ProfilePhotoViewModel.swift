//  ProfilePhotoViewModel.swift
//  Created by Aum Chauhan on 24/07/23.

import Foundation
import SwiftUI
import Combine

class ProfilePhotoViewModel: ObservableObject {
    
    private let urlString: String
    var cancellables = Set<AnyCancellable>()
    
    private let service = FileManagerService()
    private let imageKey: String
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
  
    init(url: String, key: String) {
        urlString = url
        imageKey = key
        getImage()
    }
    
    func getImage() {
        if let savedImage = service.get(key: imageKey) {
            image = savedImage
            print("Getting Saved Image...")
        } else {
            downloadImage()
            print("Downloading Images....")
        }
    }
    
    func downloadImage() {
        isLoading = true
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (_) in
                withAnimation {
                    self?.isLoading = false
                }
            } receiveValue: { [weak self] returnImage in
                withAnimation {
                    guard let self = self,
                          let images = returnImage else { return }
                    self.image = images
                    self.service.add(key: self.imageKey, image: images)
                }
            }
            .store(in: &cancellables)
    }
}

