//
//  Post.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/17/23.
//

import Foundation
import FirebaseFirestoreSwift


struct Post: Identifiable, Codable  {
    let id: String
    var userID: String
    let imageURL: String
}
