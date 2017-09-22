//
//  Math.swift
//  snoogle
//
//  Created by Vincent Moore on 7/21/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
    func fit(in size: CGSize) -> CGSize {
        let aspectWidth = size.width / self.width
        let aspectHeight = size.height / self.height
        let ratio = min(aspectWidth, aspectHeight)
        let newWidth = self.width * ratio
        let newHeight = self.height * ratio
        return CGSize(width: newWidth, height: newHeight)
    }
}

let aspectSize: (_ sizeToFit: CGSize, _ originalSize: CGSize) -> CGSize = { sizeToFit, originSize in
    let aspectWidth = sizeToFit.width / originSize.width
    let aspectHeight = sizeToFit.height / originSize.height
    let ratio = min(aspectWidth, aspectHeight)
    let newWidth = originSize.width * ratio
    let newHeight = originSize.height * ratio
    print(originSize.height)
    return CGSize(width: newWidth, height: newHeight)
}

let aspectHeight: (_ sizeToFit: CGSize, _ originalSize: CGSize) -> CGFloat = { sizeToFit, originSize in
    return aspectSize(sizeToFit, originSize).height
}

let aspectWidth: (_ sizeToFit: CGSize, _ originalSize: CGSize) -> CGFloat = { sizeToFit, originSize in
    return aspectSize(sizeToFit, originSize).width
}
