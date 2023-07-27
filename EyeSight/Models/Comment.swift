//
//  Comment.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/26/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Comment: Identifiable, Codable {
    let id: String
    let commentSectionID: String // The id of the chat this message is part of
    let senderID: String // The id of the user who sent this message
    let timestamp: Timestamp
    let text: String
}
