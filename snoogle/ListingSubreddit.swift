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
    dynamic var subreddit: Subreddit? = nil
    dynamic var sort: String = ""
    dynamic var id: String = ""
    
    dynamic var after: String? {
        return submissions.last?.name
    }
    
    let submissions = List<Submission>()
    
    required convenience init(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        sort        <- map["sort"]
        subreddit   <- map["subreddit"]
        
        if let subreddit = subreddit, let sortType = ListingSort(rawValue: sort) {
            id = "listing:\(subreddit.id):\(sortType.rawValue)"
        }
    }
}

extension ListingSubreddit {
    static func createId(subId: String, sort: ListingSort) -> String {
        return "listing:\(subId):\(sort.rawValue)"
    }
}
