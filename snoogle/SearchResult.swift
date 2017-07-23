//
//  SearchResult.swift
//  snoogle
//
//  Created by Vincent Moore on 7/23/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class SearchResult: Object, Mappable {
    
    dynamic var id: String = ""
    dynamic var term: String = ""
    
    var photos = List<Submission>()
    var videos = List<Submission>()
    var discussions = List<Submission>()
    var links = List<Submission>()
    var subreddits = List<Subreddit>()
    
    required convenience init(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {}
}
