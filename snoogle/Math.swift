//
//  Math.swift
//  snoogle
//
//  Created by Vincent Moore on 7/21/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

let aspectHeight: (_ sizeToFit: CGSize, _ originalSize: CGSize) -> CGFloat = { sizeToFit, originSize in
    let aspectWidth = sizeToFit.width / originSize.width
    let aspectHeight = sizeToFit.height / originSize.height
    let ratio = min(aspectWidth, aspectHeight)
    let newHeight = originSize.height * ratio
    return newHeight
}
