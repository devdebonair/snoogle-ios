//
//  Media.swift
//  snoogle
//
//  Created by Vincent Moore on 3/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class Media: Object, Mappable {
    dynamic var type: String = ""
    dynamic var height: Double = 0
    dynamic var width: Double = 0
    dynamic var url: String = ""
    dynamic var info: String = ""
    dynamic var small: String? = nil
    dynamic var medium: String? = nil
    dynamic var large: String? = nil
    dynamic var huge: String? = nil
    dynamic var poster: String? = nil
    dynamic var gif: String? = nil
    dynamic var title: String? = nil
    
    var urlOrigin: URL? {
        return URL(string: url)
    }
    
    var urlSmall: URL? {
        guard let small = small else { return nil }
        return URL(string: small)
    }
    
    var urlMedium: URL? {
        guard let medium = medium else { return nil }
        return URL(string: medium)
    }
    
    var urlLarge: URL? {
        guard let large = large else { return nil }
        return URL(string: large)
    }
    
    var urlHuge: URL? {
        guard let huge = huge else { return nil }
        return URL(string: huge)
    }
    
    var urlPoster: URL? {
        guard let poster = poster else { return nil }
        return URL(string: poster)
    }
    
    var urlGif: URL? {
        guard let gif = gif else { return nil }
        return URL(string: gif)
    }
    
    var mediaType: MediaType? {
        return MediaType(rawValue: type)
    }
    
    required convenience init(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        type    <- map["type"]
        height  <- map["height"]
        width   <- map["width"]
        url     <- map["url"]
        info    <- map["description"]
        small   <- map["sizes.small"]
        medium  <- map["sizes.medium"]
        large   <- map["sizes.large"]
        huge    <- map["sizes.huge"]
        poster  <- map["poster"]
        gif     <- map["gif"]
        title   <- map["title"]
    }
}
