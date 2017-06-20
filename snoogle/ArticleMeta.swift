//
//  ArticleMeta.swift
//  snoogle
//
//  Created by Vincent Moore on 6/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class ArticleMeta: Object, Mappable {
    dynamic var id: String = UUID().uuidString
    dynamic var type: String? = nil
    dynamic var rangeStart: Int = 0
    dynamic var rangeEnd: Int = 0
    dynamic var urlString: String? = nil
    
    var url: URL? {
        guard let urlString = urlString else { return nil }
        return URL(string: urlString)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        type        <- map["type"]
        urlString   <- map["url"]
        rangeStart  <- map["range.start"]
        rangeEnd    <- map["range.end"]
    }
}
