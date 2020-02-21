//
//  UserID.swift
//  303 Patterns Note
//
//  Created by 服部　翼 on 2020/02/21.
//  Copyright © 2020 服部翼. All rights reserved.
//

import Foundation


class User {
    
    var id: String?
    
    init() {
        if UserDefaults.standard.object(forKey: "userID") == nil {
            self.id = Randomize().generate()
            UserDefaults.standard.set(self.id, forKey: "userID")
        } else {
            self.id = UserDefaults.standard.string(forKey: "userID")
        }
    }
}
