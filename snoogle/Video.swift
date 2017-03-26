//
//  Video.swift
//  snoogle
//
//  Created by Vincent Moore on 12/28/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

class Video: NSObject, MediaElement {
    var width: Double = 0.0
    var height: Double = 0.0
    var url: URL?
    var poster: URL?
    var gif: URL?
    var info: String?
    
    init(width: Double, height: Double, url: URL?, poster: URL?, gif: URL?, info: String?) {
        self.width = width
        self.height = height
        self.url = url
        self.poster = poster
        self.gif = gif
        self.info = info
    }
}
