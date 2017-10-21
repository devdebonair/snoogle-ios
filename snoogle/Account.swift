//
//  User.swift
//  snoogle
//
//  Created by Vincent Moore on 3/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class Account: Object, Mappable {
    enum AccountError: Error {
        case invalidSubreddit
    }
    
    dynamic var isEmployee: Bool = false
    dynamic var isSuspended: Bool = false
    dynamic var id: String = ""
    dynamic var isOver18: Bool = false
    dynamic var isGold: Bool = false
    dynamic var isMod: Bool = false
    dynamic var hasVerifiedEMail: Bool = false
    dynamic var linkKarma: Int = 0
    dynamic var inboxCount: Int = 0
    dynamic var hasMail: Int = 0
    dynamic var name: String = ""
    dynamic var created: Date = Date()
    dynamic var commentKarma: Int = 0
    
    var subredditSubscriptions = List<Subreddit>()
    var multireddits = List<Multireddit>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        isEmployee              <- map["is_employee"]
        isSuspended             <- map["is_suspended"]
        id                      <- map["id"]
        isOver18                <- map["over_18"]
        isGold                  <- map["is_gold"]
        isMod                   <- map["is_mod"]
        hasVerifiedEMail        <- map["has_verified_email"]
        linkKarma               <- map["link_karma"]
        inboxCount              <- map["inbox_count"]
        hasMail                 <- map["has_mail"]
        name                    <- map["name"]
        created                 <- (map["created"], DateTransform())
        commentKarma            <- map["comment_karma"]
        subredditSubscriptions  <- (map["hamlet_subscriptions"], ListTransform<Subreddit>())
        multireddits            <- (map["hamlet_multireddits"], ListTransform<Multireddit>())
    }
    
    func isSubscribed(to subreddit: String) -> Bool {
        let subscriptionNames = self.subredditSubscriptions.map { (subreddit) -> String in
            return subreddit.displayName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        }
        return subscriptionNames.contains(subreddit.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
    }
    
    func subscribe(to subreddit: String, realm: Realm) throws {
        let subreddit = Query<Subreddit>().key("displayName").eqlStr(subreddit).exec(realm: realm).first
        guard let guardedSubreddit = subreddit else { throw AccountError.invalidSubreddit }
        self.subredditSubscriptions.append(guardedSubreddit)
    }
    
    func unsubscribe(from subreddit: String, realm: Realm) throws {
        let subreddit = Query<Subreddit>().key("displayName").eqlStr(subreddit).exec(realm: realm).first
        guard let guardedSubreddit = subreddit else { throw AccountError.invalidSubreddit }
        if let index = self.subredditSubscriptions.index(of: guardedSubreddit) {
            self.subredditSubscriptions.remove(at: index)
        }
    }
    
    func getConfig() -> AccountConfig? {
        do {
            let realm = try Realm()
            return self.getConfig(realm: realm)
        } catch {
            print(error)
            return nil
        }
    }
    
    func getConfig(realm: Realm) -> AccountConfig? {
        return AccountConfig.getConfig(for: self.name, realm: realm)
    }
}
