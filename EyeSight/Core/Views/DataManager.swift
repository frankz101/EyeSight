//
//  DataManager.swift
//  EyeSight
//
//  Created by Andy Ren on 9/9/23.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    var friends: [Friend] = []
}
