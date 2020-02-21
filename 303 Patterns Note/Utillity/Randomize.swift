//
//  Randomize.swift
//  303 Patterns Note
//
//  Created by 服部翼 on 2020/02/21.
//  Copyright © 2020 服部翼. All rights reserved.
//

import Foundation


struct Randomize {
    
    func generate() -> String {
        
        let base: NSString = "0123456789"
        let len = UInt32(base.length)
        var randomString:String = ""
        
        for _ in 0 ..< 9 {
            let randomaize = arc4random_uniform(len)
            var nextChar = base.character(at: Int(randomaize))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
