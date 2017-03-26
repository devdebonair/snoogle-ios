//
//  Media.swift
//  snoogle
//
//  Created by Vincent Moore on 3/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift

class Media: Object {
    dynamic var type: String = ""
    dynamic var height: Int = 0
    dynamic var width: Int = 0
    dynamic var url: String = ""
    dynamic var info: String = ""
    dynamic var small: String? = nil
    dynamic var medium: String? = nil
    dynamic var large: String? = nil
    dynamic var poster: String? = nil
    dynamic var gif: String? = nil
    
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
    
    var urlPoster: URL? {
        guard let poster = poster else { return nil }
        return URL(string: poster)
    }
    
    var urlGif: URL? {
        guard let gif = gif else { return nil }
        return URL(string: gif)
    }
}
