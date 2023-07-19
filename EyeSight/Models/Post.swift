//
//  Post.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/17/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore


struct Post: Identifiable, Codable  {
    let id: String
    var userID: String
    var username: String
    let imageURL: String
    let timestamp: Timestamp
    let location: GeoPoint
    var state: String
    var town: String
}
