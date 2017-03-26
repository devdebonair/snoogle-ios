//
//  User.swift
//  snoogle
//
//  Created by Vincent Moore on 3/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class User: Object, Mappable {
    dynamic var isFriend: Bool = false // account specific
    dynamic var id: String = ""
    dynamic var isGold: Bool = false
    dynamic var isMod: Bool = false
    dynamic var hasVerifiedMail: Bool = false
    dynamic var linkKarma: Int = 0
    dynamic var name: String = ""
    dynamic var created: Date = Date()
    dynamic var commentKarma: Int = 0
    
    required convenience init(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    func mapping(map: Map) {
        isFriend            <- map["is_friend"]
        id                  <- map["id"]
        isGold              <- map["is_gold"]
        isMod               <- map["is_mod"]
        hasVerifiedMail     <- map["has_verified_email"]
        linkKarma           <- map["link_karma"]
        name                <- map["name"]
        created             <- (map["created"], DateTransform())
        commentKarma        <- map["comment_karma"]
    }
}
