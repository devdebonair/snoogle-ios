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
    
    var height: CGFloat { get set }
    var width: CGFloat { get set }
    var url: URL? { get set }
    
}
