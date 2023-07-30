//
//  FriendRequest.swift
//  EyeSight
//
//  Created by Andy Ren on 7/30/23.
//

import Foundation
import FirebaseFirestoreSwift

struct FriendRequest: Identifiable, Codable {
    @DocumentID var id: String?
    var senderId: String
    var receiverId: String
}
