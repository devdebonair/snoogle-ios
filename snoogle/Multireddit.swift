//
//  Multireddit.swift
//  snoogle
//
//  Created by Vincent Moore on 3/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class Multireddit: Object, Mappable {
    dynamic var canEdit: Bool = false
    dynamic var displayName: String = ""
    dynamic var name: String = ""
    dynamic var created: Date = Date()
    dynamic var copiedFrom: String? = nil
    dynamic var iconUrl: String? = nil
    dynamic var keyColor: String = ""
    dynamic var visibility: String = ""
    dynamic var iconName: String = ""
    dynamic var info: String = ""
    dynamic var curator: String = ""
    
    let subreddits = List<Subreddit>()
    
    var urlIcon: URL? {
        guard let iconUrl = iconUrl else { return nil }
        return URL(string: iconUrl)
    }
    
    dynamic var id: String = ""
    
    required convenience init(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        canEdit         <- map["can_edit"]
        displayName     <- map["display_name"]
        name            <- map["name"]
        created         <- (map["created"], DateTransform())
        copiedFrom      <- map["copied_from"]
        iconUrl         <- map["icon_url"]
        keyColor        <- map["key_color"]
        visibility      <- map["visibility"]
        iconName        <- map["icon_name"]
        info            <- map["description_md"]
        curator         <- map["curator.name"]
        
        id = "multireddit:\(curator):\(name)"
        
        guard let subs = map.JSON["subreddits"] as? [[String:Any]] else { return }
        
        do {
            let realm = try Realm()
            try realm.write {                
                for subJSON in subs {
                    let extractedSubJSON = Multireddit.formatSubreddit(json: subJSON)
                    let id = extractedSubJSON["id"]
                    let existingSub = realm.object(ofType: Subreddit.self, forPrimaryKey: id)
                    if let _ = id, let _ = existingSub {
                        let updatedSub = realm.create(Subreddit.self, value: extractedSubJSON, update: true)
                        subreddits.append(updatedSub)
                    } else {
                        guard let newSub = Subreddit(JSON: subJSON) else { continue }
                        subreddits.append(newSub)
                    }
                }
            }
        } catch {
            print(error)
        }
    }

    // Strategy to prevent overwrites from inconsistent data.
    // Reddit does not return the full subreddit json
    // This is needed because the keys in Subreddit do not match
    //      the keys returned by the api. snake_case -> camelCase
    static func formatSubreddit(json: [String:Any]) -> [String : Any] {
        var jsonToMerge = [String:Any]()
        jsonToMerge["iconImage"] = json["icon_img"]
        jsonToMerge["bannerImage"] = json["banner_img"]
        jsonToMerge["description"] = json["description"]
        jsonToMerge["displayName"] = json["display_name"]
        jsonToMerge["publicDescription"] = json["public_description"]
        jsonToMerge["name"] = json["name"]
        jsonToMerge["subscribers"] = json["subscribers"]
        jsonToMerge["keyColor"] = json["key_color"]
        jsonToMerge["subredditType"] = json["subreddit_type"]
        jsonToMerge["headerImage"] = json["header_img"]
        if let name = jsonToMerge["name"] as? String {
            jsonToMerge["id"] = Subreddit.getId(from: name)
        }
        return jsonToMerge
    }
}
