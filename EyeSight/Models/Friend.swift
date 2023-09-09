//
//  Friends.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/16/23.
//

import Foundation

struct Friend: Identifiable {
    var id: String
    var name: String
    let locationId: String
    var profileImageURL: String?
    var town: String?
    var state: String?
    var distance: Double?
}
