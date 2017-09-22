//
//  ASVideoNode+Thumbnail.swift
//  snoogle
//
//  Created by Vincent Moore on 9/11/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

extension ASVideoNode {
    func generateThumbnail(percentage: Double) -> UIImage? {
        guard let currentItem = currentItem, let asset = self.asset else { return nil }
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTime(seconds: currentItem.duration.seconds * percentage, preferredTimescale: 1)
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage:imageRef)
            return thumbnail
        } catch {
            return nil
        }
    }
}
