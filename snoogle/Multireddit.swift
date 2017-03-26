//
//  Multireddit.swift
//  snoogle
//
//  Created by Vincent Moore on 3/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class Multireddit: Object, Mappable {
    dynamic var canEdit: Bool = false
    dynamic var displayName: String = ""
    dynamic var name: String = ""
    dynamic var created: Date = Date()
    dynamic var copiedFrom: String? = nil
    dynamic var iconUrl: String? = nil
    dynamic var keyColor: String = ""
    dynamic var visibility: String = ""
    dynamic var iconName: String = ""
    dynamic var info: String = ""
    dynamic var curator: String = ""
    
    let subreddits = List<Subreddit>()
    
    var urlIcon: URL? {
        guard let iconUrl = iconUrl else { return nil }
        return URL(string: iconUrl)
    }
    
    dynamic var id: String = ""
    
    required convenience init(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        canEdit         <- map["can_edit"]
        displayName     <- map["display_name"]
        name            <- map["name"]
        created         <- (map["created"], DateTransform())
        copiedFrom      <- map["copied_from"]
        iconUrl         <- map["icon_url"]
        keyColor        <- map["key_color"]
        visibility      <- map["visibility"]
        iconName        <- map["icon_name"]
        info            <- map["description_md"]
        curator         <- map["curator.name"]
        
        id = "multireddit:\(curator):\(name)"
    }
}
