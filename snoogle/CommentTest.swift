////
////  Comment.swift
////  snoogle
////
////  Created by Vincent Moore on 1/5/17.
////  Copyright © 2017 Vincent Moore. All rights reserved.
////
//
//import Foundation
//
//struct CommentTest: Mappable {
//    let subreddit_id: String
//    let banned_by: String?
//    let removal_reason: String?
//    let link_id: String
//    let likes: Int
//    let user_reports: [String]
//    let saved: Bool
//    let id: String
//    let gilded: Int
//    let archived: Bool
//    let report_reasons: [String]?
//    let author: String
//    let parent_id: String
//    let score: Int
//    let approved_by: String?
//    let controversiality: Int
//    let body: String
//    let edited: Bool
//    let author_flair_css_class: String
//    let downs: Int
//    let stickied: Bool
//    let subreddit: String
//    let score_hidden: Bool
//    let name: String
//    let created: Double
//    let author_flair_text: String
//    let created_utc: Double
//    let ups: Int
//    let mod_reports: [String]
//    let num_reports: Int?
//    let distinguished: Bool?
//    let level: Int
//    
//    init(map: Mapper) throws {
//        subreddit_id = map.optionalFrom("subreddit_id") ?? ""
//        banned_by = map.optionalFrom("banned_by") ?? ""
//        removal_reason = map.optionalFrom("removal_reason") ?? ""
//        link_id = map.optionalFrom("link_id") ?? ""
//        likes = map.optionalFrom("likes") ?? 0
//        user_reports = map.optionalFrom("user_reports") ?? []
//        saved = map.optionalFrom("saved") ?? false
//        id = map.optionalFrom("id") ?? ""
//        gilded = map.optionalFrom("gilded") ?? 0
//        archived = map.optionalFrom("archived") ?? false
//        report_reasons = map.optionalFrom("report_reasons") ?? []
//        author = map.optionalFrom("author") ?? ""
//        parent_id = map.optionalFrom("parent_id") ?? ""
//        score = map.optionalFrom("score") ?? 0
//        approved_by = map.optionalFrom("approved_by") ?? ""
//        controversiality = map.optionalFrom("controversiality") ?? 0
//        body = map.optionalFrom("body") ?? ""
//        edited = map.optionalFrom("edited") ?? false
//        author_flair_css_class = map.optionalFrom("author_flair_css_class") ?? ""
//        downs = map.optionalFrom("downs") ?? 0
//        stickied = map.optionalFrom("stickied") ?? false
//        subreddit = map.optionalFrom("subreddit") ?? ""
//        score_hidden = map.optionalFrom("score_hidden") ?? false
//        name = map.optionalFrom("name") ?? ""
//        created = map.optionalFrom("created") ?? 0.0
//        author_flair_text = map.optionalFrom("author_flair_text") ?? ""
//        created_utc = map.optionalFrom("created_utc") ?? 0.0
//        ups = map.optionalFrom("ups") ?? 0
//        mod_reports = map.optionalFrom("mod_reports") ?? []
//        num_reports = map.optionalFrom("num_reports") ?? 0
//        distinguished = map.optionalFrom("distinguished") ?? false
//        level = map.optionalFrom("level") ?? 0
//    }
//}
