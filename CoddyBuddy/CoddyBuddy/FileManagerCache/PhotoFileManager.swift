import Foundation
import SwiftUI

class saveDataFm: ObservableObject {
    
    static let instance = saveDataFm()
    private var cachedDirectorys: URL? {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }
    
    func saveData(model: PostedQuery_MetaData) {
        
        guard let cachedDirectory = cachedDirectorys else { return }
        
        let fileURL = cachedDirectory.appendingPathComponent("data" + ".cache")
        
        let data = try? JSONEncoder().encode(model)
        
        do {
            try data?.write(to: fileURL)
            print("datastored FM")
        } catch let error {
            print("Errror \(error)")
        }
    }
    
    func fetchData(with fileName: String) -> PostedQuery_MetaData? {
        guard let cachedDirectory = cachedDirectorys else { return nil }
        
        let fileURL = cachedDirectory.appendingPathComponent("data" + ".cache")
        
        guard let data = try? Data(contentsOf: fileURL),
              let item = try? JSONDecoder().decode(PostedQuery_MetaData.self, from: data)
        else { return nil }
        
        print("fetching data")
        return item
    }
    
}
