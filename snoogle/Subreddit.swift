//
//  Subreddit.swift
//  snoogle
//
//  Created by Vincent Moore on 3/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class Subreddit: Object, Mappable {
    dynamic var bannerImage: String? = nil
    dynamic var wikiEnabled: Bool = false
    dynamic var showMedia: Bool = false
    dynamic var id: String = ""
    dynamic var info: String = ""
    dynamic var submitText: String = ""
    dynamic var displayName: String = ""
    dynamic var headerImage: String? = nil
    dynamic var title: String = ""
    dynamic var publicDescription: String = ""
    dynamic var spoilersEnabled: Bool = false
    dynamic var iconImage: String? = nil
    dynamic var headerTitle: String? = nil
    dynamic var accountsActive: Int = 0
    dynamic var subscribers: Int = 0
    dynamic var keyColor: String = ""
    dynamic var name: String = ""
    dynamic var created: Date = Date()
    dynamic var quarantined: Bool = false
    dynamic var subredditType: String = "public"
    dynamic var submissionType: String = "any"
    dynamic var isNSFW: Bool = false
    dynamic var publicDescriptionStripped: String = ""
    
    var urlIconImage: URL? {
        guard let iconImage = iconImage else { return nil }
        return URL(string: iconImage)
    }
    
    var urlHeaderImage: URL? {
        guard let headerImage = headerImage else { return nil }
        return URL(string: headerImage)
    }
    
    var urlBannerImage: URL? {
        guard let bannerImage = bannerImage else { return nil }
        return URL(string: bannerImage)
    }
    
    var urlValidImage: URL? {
        if let iconImage = iconImage, let urlIconImage = urlIconImage, !iconImage.isEmpty {
            return urlIconImage
        } else if let bannerImage = bannerImage, let urlBannerImage = urlBannerImage, !bannerImage.isEmpty {
            return urlBannerImage
        } else if let headerImage = headerImage, let urlHeaderImage = urlHeaderImage, !headerImage.isEmpty {
            return urlHeaderImage
        } else {
            return nil
        }
    }
    
    required convenience init(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func getListing(sort: ListingSort) throws -> ListingSubreddit? {
        let realm = try Realm()
        return realm.object(ofType: ListingSubreddit.self, forPrimaryKey: "listing:\(displayName):\(sort.rawValue)")
    }
    
    func mapping(map: Map) {
        bannerImage                 <- map["banner_img"]
        wikiEnabled                 <- map["wiki_enabled"]
        showMedia                   <- map["show_media"]
        id                          <- map["id"]
        info                        <- map["description"]
        submitText                  <- map["submit_text"]
        displayName                 <- map["display_name"]
        headerImage                 <- map["header_img"]
        title                       <- map["title"]
        publicDescription           <- map["public_description"]
        spoilersEnabled             <- map["spoilers_enabled"]
        iconImage                   <- map["icon_img"]
        headerTitle                 <- map["header_title"]
        accountsActive              <- map["accounts_active"]
        subscribers                 <- map["subscribers"]
        keyColor                    <- map["key_color"]
        name                        <- map["name"]
        quarantined                 <- map["quarantine"]
        subredditType               <- map["subreddit_type"]
        submissionType              <- map["submission_type"]
        isNSFW                      <- map["over18"]
        created                     <- (map["created"], DateTransform())
        publicDescriptionStripped   <- map["public_description_stripped"]
        
        // Fetching subreddits in multireddits do not provide id
        // First 3 characters are the type of [Thing] and the rest is the id [t5_]30cz1 -> 30cz1
        if id.isEmpty && !name.isEmpty && name.characters.count > 3 {
            id = Subreddit.getId(from: name)
        }
    }
}

extension Subreddit {
    static func getId(from name: String) -> String {
        return name[3..<name.characters.count]
    }
}
