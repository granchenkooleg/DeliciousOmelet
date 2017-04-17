//
//  Food.swift
//  DeliciousOmelet
//
//  Created by Oleg on 3/25/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

extension Results {
    func array<T>(ofType: T.Type) -> [T] {
        return flatMap { $0 as? T }
    }
}

class Foods : Object {
    
    dynamic var title = ""
    dynamic var href = ""
    var results = List<Result>()
    
    @discardableResult static func setupFood(json: JSON) -> Foods {
        var foods = Foods()
        let realm = try! Realm()
        
        try! realm.write {
            
            foods = realm.create(Foods.self, value: json.object, update: true)
            
        }
        
        return foods
    }
    
    override static func primaryKey() -> String? {
        return "title"
    }
    
    // Path to Realm
    static func setConfig() {
        let realm = try! Realm()
        if let url = realm.configuration.fileURL {
            print("FileURL of DataBase - \(url)")
        }
    }
    
    func allFood() -> [Result] {
        let realm = try! Realm()
        let list =  realm.objects(Result.self)
        return Array(list)
    }
    
    static func delAllFoods() {
        let realm = try! Realm()
        let allFoods = realm.objects(Result.self)
        try! realm.write {
            realm.delete(allFoods)
        }
    }
}

class Result : Object {
    dynamic var title = ""
    dynamic var href = ""
    dynamic var ingredients = ""
    dynamic var thumbnail = ""
    
    override static func primaryKey() -> String? {
        return "title"
    }
}
