//
//  CommentSection.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/26/23.
//

import Foundation

struct CommentSection: Identifiable, Codable {
    let id: String
    var participants: [String] // The ids of the users in this chat
    // A chat could also include things like the last message sent, or the last time the chat was updated
}
