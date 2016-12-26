//
//  Listing.swift
//  snoogle
//
//  Created by Vincent Moore on 12/24/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import Mapper

struct Listing: Mappable {
    enum SortType: String {
        case hot = "hot"
        case new = "new"
        case top = "top"
        case rising = "rising"
        case controversial = "controversial"
    }
    
    let contest_mode: Bool
    let banned_by: String
    let domain: String
    let subreddit: String
    let selftext: String
    let likes: Int
    let suggested_sort: String
    let user_reports: [String]
    let saved: Bool
    let id: String
    let gilded: Int
    let clicked: Bool
    let report_reasons: String
    let author: String
    let name: String
    let score: Int
    let approved_by: String
    let over_18: Bool
    let removal_reason: String
    let hidden: Bool
    let thumbnail: URL?
    let subreddit_id: String
    let edited: Bool
    let link_flair_css_class: String
    let author_flair_css_class: String
    let downs: Int
    let mod_reports: [String]
    let archived: Bool
    let post_hint: String
    let is_self: Bool
    let hide_score: Bool
    let spoiler: Bool
    let permalink: String
    let locked: Bool
    let stickied: Bool
    let created: Double
    let url: URL?
    let author_flair_text: String
    let quarantine: Bool
    let title: String
    let created_utc: Double
    let link_flair_text: String
    let distinguished: Int
    let num_comments: Int
    let visited: Bool
    let num_reports: Int
    let ups: Int
    
    init(map: Mapper) throws {
        contest_mode = map.optionalFrom("contest_mode") ?? false
        banned_by = map.optionalFrom("banned_by") ?? ""
        domain = map.optionalFrom("domain") ?? ""
        subreddit = map.optionalFrom("subreddit") ?? ""
        selftext = map.optionalFrom("selftext") ?? ""
        likes = map.optionalFrom("likes") ?? -1
        suggested_sort = map.optionalFrom("suggested_sort") ?? ""
        user_reports = map.optionalFrom("user_reports") ?? []
        saved = map.optionalFrom("saved") ?? false
        id = map.optionalFrom("id") ?? ""
        gilded = map.optionalFrom("gilded") ?? -1
        clicked = map.optionalFrom("clicked") ?? false
        report_reasons = map.optionalFrom("report_reasons") ?? ""
        author = map.optionalFrom("author") ?? ""
        name = map.optionalFrom("name") ?? ""
        score = map.optionalFrom("score") ?? -1
        approved_by = map.optionalFrom("approved_by") ?? ""
        over_18 = map.optionalFrom("over_18") ?? false
        removal_reason = map.optionalFrom("removal_reason") ?? ""
        hidden = map.optionalFrom("hidden") ?? false
        thumbnail = map.optionalFrom("thumbnail")
        subreddit_id = map.optionalFrom("subreddit_id") ?? ""
        edited = map.optionalFrom("edited") ?? false
        link_flair_css_class = map.optionalFrom("link_flair_css_class") ?? ""
        author_flair_css_class = map.optionalFrom("author_flair_css_class") ?? ""
        downs = map.optionalFrom("downs") ?? -1
        mod_reports = map.optionalFrom("mod_reports") ?? []
        archived = map.optionalFrom("archived") ?? false
        post_hint = map.optionalFrom("post_hint") ?? ""
        is_self = map.optionalFrom("is_self") ?? false
        hide_score = map.optionalFrom("hide_score") ?? false
        spoiler = map.optionalFrom("spoiler") ?? false
        permalink = map.optionalFrom("permalink") ?? ""
        locked = map.optionalFrom("locked") ?? false
        stickied = map.optionalFrom("stickied") ?? false
        created = map.optionalFrom("created") ?? -1.0
        url = map.optionalFrom("url")
        author_flair_text = map.optionalFrom("author_flair_text") ?? ""
        quarantine = map.optionalFrom("quarantine") ?? false
        title = map.optionalFrom("title") ?? ""
        created_utc = map.optionalFrom("created_utc") ?? -1.0
        link_flair_text = map.optionalFrom("link_flair_text") ?? ""
        distinguished = map.optionalFrom("distinguished") ?? -1
        num_comments = map.optionalFrom("num_comments") ?? -1
        visited = map.optionalFrom("visited") ?? false
        num_reports = map.optionalFrom("num_reports") ?? -1
        ups = map.optionalFrom("ups") ?? -1
    }
}
