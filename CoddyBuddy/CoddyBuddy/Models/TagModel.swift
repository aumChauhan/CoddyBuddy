//  TagModel.swift
//  Created by Aum Chauhan on 01/08/23.

import Foundation
import Firebase

struct TagModel: Codable, Hashable {
    let tagName: String
    let postCount: Int
}

struct TagKeys {
    static let tagName = "tagName"
    static let postCount = "postCount"
}
