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

class Photo: MediaElement {
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var url: URL?
    var urlSmall: URL?
    var urlMedium: URL?
    var urlLarge: URL?
    var description: String = ""
}
