//
//  Submission.swift
//  snoogle
//
//  Created by Vincent Moore on 3/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class Submission: Object, Mappable {
    dynamic var contestMode: Bool = false
    dynamic var domain: String = ""
    dynamic var subredditName: String = ""
    dynamic var selftext: String = ""
    dynamic var suggestedSort: String = ""
    dynamic var id: String = ""
    dynamic var gilded: Int = 0
    dynamic var authorName: String = ""
    dynamic var name: String = ""
    dynamic var score: Int = 0
    dynamic var thumbnail: String = ""
    dynamic var subredditId: String = ""
    dynamic var edited: Bool = false
    dynamic var linkFlairCssClass: String = ""
    dynamic var authorFlairCssClass: String = ""
    dynamic var downs: Int = 0
    dynamic var archived: Bool = false
    dynamic var isSelf: Bool = false
    dynamic var hideScore: Bool = false
    dynamic var spoiler: Bool = false
    dynamic var permalink: String = ""
    dynamic var locked: Bool = false
    dynamic var stickied: Bool = false
    dynamic var created: Date = Date()
    dynamic var url: String = ""
    dynamic var authorFlairText: String = ""
    dynamic var quarantine: Bool = false
    dynamic var title: String = ""
    dynamic var linkFlairText: String = ""
    dynamic var distinguished: Int = 0
    dynamic var numComments: Int = 0
    dynamic var visited: Bool = false
    dynamic var ups: Int = 0
    dynamic var isNSFW: Bool = false
    dynamic var saved: Bool = false
    var likes = RealmOptional<Bool>()
    
    var media = List<Media>()
    
    dynamic var subreddit: Subreddit? = nil
    dynamic var author: User? = nil
    
    var urlThumbnail: URL? {
        return URL(string: thumbnail)
    }
    
    var urlOrigin: URL? {
        return URL(string: url)
    }
    
    var metaIgnoreSub: String {
        var metaString = "\(authorName) • \(created.timeAgo(shortened: true))"
        if domain.lowercased() != "self.\(subredditName)".lowercased() {
            metaString = "\(metaString)  • \(domain)"
        }
        metaString += (score != 1) ? " • \(score) points" : " • \(score) point"
        return metaString
    }
    
    var meta: String {
        return "\(metaIgnoreSub) • \(subredditName)"
    }
    
    var selftextCondensed: String {
        let arrayOfWords = selftext.components(separatedBy: .whitespacesAndNewlines)
        let retval = arrayOfWords.joined(separator: " ")
        let retvalWithoutBangs = retval.replacingOccurrences(of: "#", with: "")
        return retvalWithoutBangs
    }
    
    var selftextTruncated: String {
        var descriptionShortened = selftextCondensed
        let maxCharacterLimit = 250
        if descriptionShortened.characters.count > maxCharacterLimit {
            descriptionShortened = descriptionShortened[0..<maxCharacterLimit]
            var arrayOfWords = descriptionShortened.components(separatedBy: .whitespacesAndNewlines)
            let _ = arrayOfWords.popLast()
            arrayOfWords.append(" ... (more)")
            descriptionShortened = arrayOfWords.joined(separator: " ")
        }
        return descriptionShortened
    }
    
    var selftextComponents: [String] {
        return selftext.components(separatedBy: .newlines)
    }
    
    var vote: VoteType {
        guard let guardedLikes = likes.value else { return .none }
        return guardedLikes ? .up : .down
    }
    
    required convenience init(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        contestMode             <- map["contest_mode"]
        domain                  <- map["domain"]
        subredditName           <- map["subreddit"]
        selftext                <- map["selftext"]
        suggestedSort           <- map["suggested_sort"]
        id                      <- map["id"]
        gilded                  <- map["gilded"]
        authorName              <- map["author"]
        name                    <- map["name"]
        score                   <- map["score"]
        thumbnail               <- map["thumbnail"]
        subredditId             <- map["subreddit_id"]
        edited                  <- map["edited"]
        linkFlairCssClass       <- map["link_flair_css_class"]
        authorFlairCssClass     <- map["author_flair_css_class"]
        downs                   <- map["downs"]
        archived                <- map["archived"]
        isSelf                  <- map["is_self"]
        hideScore               <- map["hide_score"]
        spoiler                 <- map["spoiler"]
        permalink               <- map["permalink"]
        locked                  <- map["locked"]
        stickied                <- map["stickied"]
        created                 <- map["created"]
        url                     <- map["url"]
        authorFlairText         <- map["author_flair_text"]
        quarantine              <- map["quarantine"]
        title                   <- map["title"]
        linkFlairText           <- map["link_flair_text"]
        distinguished           <- map["distinguished"]
        numComments             <- map["num_comments"]
        ups                     <- map["ups"]
        isNSFW                  <- map["over_18"]
        saved                   <- map["saved"]
        created                 <- (map["created"], DateTransform())
        
        if let likesData = map.JSON["likes"] as? Bool {
            likes.value = likesData
        } else {
            likes.value = nil
        }
        
        
        media                   <- (map["hamlet_album"], ListTransform<Media>())
        
        let singleMediaJSON = map.JSON["hamlet_media"] as? [String:Any]
        if let singleMediaJSON = singleMediaJSON, let singleMedia = Media(JSON: singleMediaJSON) {
            media.append(singleMedia)
        }
        
    }
}
