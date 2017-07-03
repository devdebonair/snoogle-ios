//
//  Listing.swift
//  snoogle
//
//  Created by Vincent Moore on 3/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class ListingSubreddit: Object, Mappable {
    dynamic var sort: String = ""
    dynamic var id: String = ""
    dynamic var name: String = ""
    
    dynamic var after: String? {
        return submissions.last?.name
    }
    
    var submissions = List<Submission>()
    
    required convenience init(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        sort        <- map["sort"]
        name        <- map["name"]
        submissions <- (map["submissions"], ListTransform<Submission>())
        
        id = "listing:\(name):\(sort)"
    }
}
