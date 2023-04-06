import Foundation
import SwiftUI
import Combine

class ImageLoadingVM: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    let urlString: String
    var cancellables = Set<AnyCancellable>()
    
    let manager = FileManagerNewsRoom.instance
    let imageKey: String
    
    init(url: String, key: String) {
        urlString = url
        imageKey = key
        getImage()
    }
    
    func getImage() {
        if let savedImage = manager.get(key: imageKey) {
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
                self?.isLoading = false
            } receiveValue: { [weak self] returnImage in
                guard let self = self,
                      let images = returnImage else { return }
                self.image = images
                self.manager.add(key: self.imageKey, image: images)
            }
            .store(in: &cancellables)
    }
}

