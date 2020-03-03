//
//  RealmManager.swift
//  303 Patterns Note
//
//  Created by 服部　翼 on 2020/02/21.
//  Copyright © 2020 服部翼. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static func addEntity<T: Object>(object: T) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object, update: true)
        }
        //print("realmファイル場所: \(Realm.Configuration.defaultConfiguration.fileURL!)")
    }
    
    static func deleteEntity<T: Object>(object: T) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(object)
        }
    }
    
    static func getEntityList<T: Object>(type: T.Type) -> Results<T> {
        let realm = try! Realm()
        return realm.objects(type.self)
    }
    
    static func filterEntityList<T: Object>(type: T.Type, property: String, filter: Any) -> Results<T> {
        return getEntityList(type: type).filter("%K == %@", property, String(describing: filter))
    }
    
}
