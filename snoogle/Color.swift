//
//  Color.swift
//  snoogle
//
//  Created by Vincent Moore on 10/7/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class Color: Object {
    dynamic var red: Int = 0
    dynamic var green: Int = 0
    dynamic var blue: Int = 0
    dynamic var alpha: Double = 1.0
    dynamic var id: String = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
