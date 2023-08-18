//  Query.swift
//  Created by Aum Chauhan on 22/07/23.

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Query {
    func getDocument<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapShot = try await self.getDocuments()
        
        var genericArray: [T] = []
        
        for document in snapShot.documents {
            let element = try document.data(as: T.self)
            genericArray.append(element)
        }
        
        return genericArray
    }
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapShot = try await self.getDocuments()
        
        var genericArray: [T] = []
        
        for document in snapShot.documents {
            let element = try document.data(as: T.self)
            genericArray.append(element)
        }
        
        return genericArray
    }
    
    func getDocumentWithLastDocuments<T>(as type: T.Type) async throws -> ([T], DocumentSnapshot?) where T : Decodable {
        let snapShot = try await self.getDocuments()
        
        var genericArray: [T] = []
        
        for document in snapShot.documents {
            let element = try document.data(as: T.self)
            genericArray.append(element)
        }
        
        return (genericArray, snapShot.documents.last)
    }
    
    func aggregateCount() async throws -> Int {
        let snapShot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapShot.count)
    }
    
    func snapShotlistner<T>(as type: T.Type, completionHandler: @escaping (([T]?, DocumentSnapshot?)) -> ()) where T : Decodable {
        self
            .addSnapshotListener { querySnapShot, error in
                guard let documents = querySnapShot?.documents else {
                    return
                }
                
                let genericArray: [T] = documents.compactMap({ try? $0.data(as: T.self) })
                
                guard let lastSnapDoc = querySnapShot?.documents.last else { return }
                
                completionHandler((genericArray, lastSnapDoc))
            }
    }
}
