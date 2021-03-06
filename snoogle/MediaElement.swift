//
//  MediaElement.swift
//  snoogle
//
//  Created by Vincent Moore on 12/28/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

protocol MediaElement {
    var height: Double { get set }
    var width: Double { get set }
    var url: URL? { get set }
}
