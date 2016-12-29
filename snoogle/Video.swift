//
//  Video.swift
//  snoogle
//
//  Created by Vincent Moore on 12/28/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import Mapper

struct Video: MediaElement, Mappable {
    var width: Double = 0.0
    var height: Double = 0.0
    var url: URL?
    var poster: URL?
    var gif: URL?
    var description: String = ""
    
    init(map: Mapper) throws {
        width = map.optionalFrom("width") ?? 0.0
        height = map.optionalFrom("height") ?? 0.0
        url = map.optionalFrom("url")
        poster = map.optionalFrom("poster")
        gif = map.optionalFrom("gif")
        description = map.optionalFrom("description") ?? ""
    }
}
