//
//  Subreddit.swift
//  snoogle
//
//  Created by Vincent Moore on 12/24/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//
// Hello world I love you very very much how ya doing today. :)
// From Kendra with Love!

import Foundation
import Alamofire
import Mapper

struct Subreddit {
    enum SortType: String {
        case popular = "popular"
        case new = "new"
        case gold = "gold"
        case def = "default"
    }
    
    let bannerImageUrl: URL?
    let submitRules: String
    let displayName: String
    let headerImageUrl: URL?
    let title: String
    let isNSFW: Bool
    let iconImageUrl: URL?
    let headerTitle: String
    let description: String
    let numberOfSubscribers: Int
    let keyColorHex: String
    let name: String
    let createdDate: Double
    let url: String
    let publicDescription: String
    let type: String
    let kind: String
    
    init(map: Mapper) throws {
        bannerImageUrl = map.optionalFrom("data.banner_img")
        submitRules = map.optionalFrom("data.submit_text") ?? ""
        displayName = map.optionalFrom("data.display_name") ?? ""
        headerImageUrl = map.optionalFrom("data.header_img")
        title = map.optionalFrom("data.title") ?? ""
        isNSFW = map.optionalFrom("data.over18") ?? false
        iconImageUrl = map.optionalFrom("data.icon_img")
        headerTitle = map.optionalFrom("data.header_title") ?? ""
        description = map.optionalFrom("data.description") ?? ""
        numberOfSubscribers = map.optionalFrom("data.subscribers") ?? 0
        keyColorHex = map.optionalFrom("data.key_color") ?? ""
        name = map.optionalFrom("data.name") ?? ""
        createdDate = map.optionalFrom("data.created_utc") ?? 0.0
        url = map.optionalFrom("data.url") ?? ""
        publicDescription = map.optionalFrom("data.public_description") ?? ""
        type = map.optionalFrom("data.subreddit_type") ?? ""
        kind = map.optionalFrom("kind") ?? ""
    }
    
    static func fetchFrontPage(after: String? = nil, sort: Listing.SortType = .hot, completion: @escaping ([Listing], Bool, String?)->Void) {
        let url = URL(string: "\(API_URL)/frontpage/\(sort.rawValue)")
        parseListing(url: url, after: after, sort: sort, completion: completion)
    }
    
    static func fetchListing(name: String, after: String? = nil, sort: Listing.SortType = .hot, completion: @escaping ([Listing], Bool, String?)->Void) {
        let url = URL(string: "\(API_LISTING)/\(name)/\(sort.rawValue)")
        parseListing(url: url, after: after, sort: sort, completion: completion)
    }
    
    private static func parseListing(url: URL?, after: String? = nil, sort: Listing.SortType = .hot, completion: @escaping ([Listing], Bool, String?)->Void) {
        if let url = url {
            var parameters = [String:String]()
            if let after = after {
                parameters["after"] = after
            }
            Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response: DataResponse<Any>) in
                if let json = response.result.value as? NSDictionary, let data = json["data"] as? NSArray, let listings = Listing.from(data), let isFinished = json["isFinished"] as? Bool {
                    let after = json["after"] as? String
                    completion(listings, isFinished, after)
                } else {
                    completion([], false, nil)
                }
            })
        } else {
            completion([], false, nil)
        }
    }
}
