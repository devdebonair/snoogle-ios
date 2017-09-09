//
//  Comment.swift
//  snoogle
//
//  Created by Vincent Moore on 3/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class Comment: Object, Mappable {
    dynamic var subredditId: String = "" // subreddit
    dynamic var linkId: String = "" // submission
    dynamic var likes: Bool = false // account specific
    dynamic var saved: Bool = false // account specific
    dynamic var id: String = ""
    dynamic var gilded: Int = 0
    dynamic var archived: Bool = false
    dynamic var score: Int = 0
    dynamic var authorName: String = "" // User
    dynamic var parentId: String = "" // Comment
    dynamic var controversiality: Int = 0
    dynamic var body: String = ""
    dynamic var edited: Bool = false
    dynamic var authorFlairCssClass: String? = nil
    dynamic var downs: Int = 0
    dynamic var subredditName: String = "" // subreddit
    dynamic var name: String = ""
    dynamic var scoreHidden: Bool = false
    dynamic var stickied: Bool = false
    dynamic var created: Date = Date()
    dynamic var authorFlairText: String? = nil
    dynamic var distinguished: String? = nil
    dynamic var ups: Int = 0
    dynamic var level: Int = 0
    
    dynamic var author: User? = nil
    
    var meta: String {
        let pointPluralization = (score == 1 || score == -1) ? "point" : "points"
        return "\(authorName) • \(created.timeAgo(shortened: true)) • \(score) \(pointPluralization)"
    }
    
    required convenience init(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        subredditId             <- map["subreddit_id"]
        linkId                  <- map["link_id"]
        likes                   <- map["likes"]
        saved                   <- map["saved"]
        id                      <- map["id"]
        gilded                  <- map["gilded"]
        archived                <- map["archived"]
        score                   <- map["score"]
        authorName              <- map["author"]
        parentId                <- map["parent_id"]
        controversiality        <- map["controversiality"]
        body                    <- map["body"]
        edited                  <- map["edited"]
        authorFlairCssClass     <- map["author_flair_css_class"]
        downs                   <- map["downs"]
        subredditName           <- map["subreddit"]
        name                    <- map["name"]
        scoreHidden             <- map["score_hidden"]
        stickied                <- map["stickied"]
        created                 <- (map["created"], DateTransform())
        authorFlairText         <- map["author_flair_text"]
        distinguished           <- map["distinguished"]
        ups                     <- map["ups"]
        level                   <- map["level"]
    }
}
