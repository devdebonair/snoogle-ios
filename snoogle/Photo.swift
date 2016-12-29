//
//  Photo.swift
//  snoogle
//
//  Created by Vincent Moore on 12/28/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import Mapper

struct Photo: MediaElement, Mappable {
    var width: Double = 0.0
    var height: Double = 0.0
    var url: URL?
    var urlSmall: URL?
    var urlMedium: URL?
    var urlLarge: URL?
    var description: String?
    
    init(map: Mapper) throws {
        try width = map.from("width")
        try height = map.from("height")
        url = map.optionalFrom("url")
        urlSmall = map.optionalFrom("sizes.small")
        urlMedium = map.optionalFrom("sizes.medium")
        urlLarge = map.optionalFrom("sizes.large")
        description = map.optionalFrom("description")
    }
}
