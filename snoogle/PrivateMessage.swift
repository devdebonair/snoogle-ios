//
//  PrivateMessage.swift
//  snoogle
//
//  Created by Vincent Moore on 3/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class PrivateMessage: Object, Mappable {
    dynamic var body: String = ""
    dynamic var wasComment: Bool = false
    dynamic var name: String = ""
    dynamic var firstMessageName: String? = nil
    dynamic var created: Date = Date()
    dynamic var dest: String = ""
    dynamic var authorName: String = ""
    dynamic var subredditName: String? = nil
    dynamic var parentId: String? = nil
    dynamic var context: String = ""
    dynamic var replies: String = ""
    dynamic var id: String = ""
    dynamic var isNew: Bool = false
    dynamic var distinguished: String? = nil
    dynamic var subject: String = ""
    
    dynamic var subreddit: Subreddit? = nil
    dynamic var firstMessage: PrivateMessage? = nil
    dynamic var receiver: User? = nil
    dynamic var sender: User? = nil
    dynamic var parent: PrivateMessage? = nil
    
    required convenience init(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        body                <- map["body"]
        wasComment          <- map["was_comment"]
        name                <- map["name"]
        firstMessageName    <- map["firstMessage"]
        created             <- (map["created"], DateTransform())
        dest                <- map["dest"]
        authorName          <- map["author"]
        subredditName       <- map["subreddit"]
        parentId            <- map["parent_id"]
        context             <- map["context"]
        replies             <- map["replies"]
        id                  <- map["id"]
        isNew               <- map["new"]
        distinguished       <- map["distinguished"]
        subject             <- map["subject"]
    }
}
