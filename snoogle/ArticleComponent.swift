//
//  ArticleComponent.swift
//  snoogle
//
//  Created by Vincent Moore on 6/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class ArticleComponent: Object, Mappable {
    dynamic var id: String = UUID().uuidString
    dynamic var type: String? = nil
    dynamic var text: String = ""
    dynamic var lang: String? = nil
    dynamic var depth: Int = -1
    
    var meta = List<ArticleMeta>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        type        <- map["type"]
        text        <- map["value"]
        lang        <- map["lang"]
        depth       <- map["depth"]
        meta        <- (map["meta"], ListTransform<ArticleMeta>())
    }
}


