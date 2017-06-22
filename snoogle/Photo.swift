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

class Photo: NSObject, MediaElement {
    var width: Double = 0.0
    var height: Double = 0.0
    var url: URL?
    var urlSmall: URL?
    var urlMedium: URL?
    var urlLarge: URL?
    var urlHuge: URL?
    var info: String?
    
    init(width: Double, height: Double, url: URL?, urlSmall: URL? = nil, urlMedium: URL? = nil, urlLarge: URL? = nil, urlHuge: URL? = nil, info: String? = nil) {
        self.width = width
        self.height = height
        self.url = url
        self.urlSmall = urlSmall
        self.urlMedium = urlMedium
        self.urlLarge = urlLarge
        self.urlHuge = urlHuge
        self.info = info
    }
}
