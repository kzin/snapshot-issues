//
//  User.swift
//  swift-testing
//
//  Created by Rodrigo Cavalcante on 03/03/17.
//  Copyright © 2017 Rodrigo Cavalcante. All rights reserved.
//

import Foundation

struct User{
    
    let username: String
    let email: String
    let age: Int
    
    init?(json: JsonObject) {
        guard let username = json["username"] as? String else {
            return nil
        }
        
        guard let email = json["email"] as? String else {
            return nil
        }
        
        guard let age = json["age"] as? Int else {
            return nil
        }
        
        self.username = username
        self.age = age
        self.email = email
    }
}
