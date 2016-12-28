//
//  Video.swift
//  snoogle
//
//  Created by Vincent Moore on 12/28/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

struct Video: MediaElement {
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var url: URL?
    var poster: URL?
    var gif: URL?
    var description: String = ""
}
