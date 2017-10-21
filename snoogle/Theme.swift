//
//  Theme.swift
//  snoogle
//
//  Created by Vincent Moore on 10/7/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class Theme: Object {
    dynamic var backgroundColor: Color? = nil
    dynamic var colorCellBackground: Color? = nil
    dynamic var colorTextPrimary: Color? = nil
    dynamic var colorTextSecondary: Color? = nil
    dynamic var colorNavigation: Color? = nil
    dynamic var colorToolbar: Color? = nil
    dynamic var colorToolbarItem: Color? = nil
    dynamic var colorNavigationItem: Color? = nil
    dynamic var colorCellAccessory: Color? = nil
    dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    static func get(name: String) throws -> Theme? {
        let realm = try Realm()
        return realm.object(ofType: Theme.self, forPrimaryKey: name)
    }
}
