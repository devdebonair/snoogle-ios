//
//  SubmissionComments.swift
//  snoogle
//
//  Created by Vincent Moore on 7/15/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class SubmissionComments: Object, Mappable {
    dynamic var sort: String = ""
    dynamic var id: String = ""
    dynamic var name: String = ""
    
    var comments = List<Comment>()
    
    required convenience init(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        sort        <- map["sort"]
        name        <- map["name"]
        comments    <- (map["comments"], ListTransform<Comment>())

        id = "comments:\(name):\(sort)"
    }
}

