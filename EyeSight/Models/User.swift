//
//  User.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import Foundation
import Firebase

struct User: Identifiable, Codable  {
    let id: String
    let fullName: String
    var email: String
    var friends: [String]?
    var hasPostedToday: Bool
    let locationId: String?
    var profileImageURL: String?
    var town: String?
    var state: String?
}
