//
//  CGRect+Distance.swift
//  snoogle
//
//  Created by Vincent Moore on 7/21/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    func distance(from: CGRect) -> CGFloat {
        let p2 = from.origin
        let p1 = origin
        let xDist = (p2.x - p1.x)
        let yDist = (p2.y - p1.y)
        return sqrt((xDist * xDist) + (yDist * yDist))
    }
}
