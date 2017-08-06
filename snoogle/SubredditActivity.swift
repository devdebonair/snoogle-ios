//
//  SubredditActivity.swift
//  snoogle
//
//  Created by Vincent Moore on 8/5/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class SubredditActivity: Object, Mappable {
    dynamic var status: String = ""
    dynamic var latestPostDate: Date = Date()
    dynamic var percentageDiscussion: Double = 0.0
    dynamic var percentageLink: Double = 0.0
    dynamic var id: String = ""
    
    required convenience init(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        status                  <- map["status"]
        latestPostDate          <- (map["latest_post"], DateTransform())
        percentageDiscussion    <- map["percentage_discussion"]
        percentageLink          <- map["percentage_link"]
        
        if let subreddit = map.JSON["subreddit"] as? String {
            id = "\(subreddit):activity"
        }
    }
}
