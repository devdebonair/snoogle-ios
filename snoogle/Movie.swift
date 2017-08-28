//
//  Movie.swift
//  snoogle
//
//  Created by Vincent Moore on 8/27/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

class Movie: NSObject, MediaElement {
    var width: Double = 0.0
    var height: Double = 0.0
    var url: URL?
    var poster: URL?
    var info: String?
    var title: String?
}

