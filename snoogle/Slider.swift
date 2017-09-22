//
//  Slider.swift
//  snoogle
//
//  Created by Vincent Moore on 9/10/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

class Slider: UISlider {
    func attachmentPoint() -> CGPoint {
        let trackRect = self.trackRect(forBounds: self.bounds)
        let thumbRect = self.thumbRect(forBounds: self.bounds, trackRect: trackRect, value: self.value)
        return CGPoint(x: thumbRect.midX + self.frame.origin.x, y: self.frame.origin.y - 50)
    }
}
