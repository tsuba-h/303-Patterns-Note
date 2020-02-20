//
//  303items.swift
//  303 Patterns Note
//
//  Created by 服部翼 on 2019/09/05.
//  Copyright © 2019 服部翼. All rights reserved.
//

import UIKit
import RealmSwift

class Contents: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var date: Date = Date()
    let note = List<Note>()
    let upDown = List<UpDown>()
    let acSlide = List<AcSlide>()
    
}

class Note: Object {
    @objc dynamic var note: String = ""
}

class UpDown: Object {
    @objc dynamic var updown: String = ""
}

class AcSlide: Object {
    @objc dynamic var acSlide: String = ""
}
