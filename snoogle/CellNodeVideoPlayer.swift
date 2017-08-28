//
//  CellNodeVideoPlayer.swift
//  snoogle
//
//  Created by Vincent Moore on 8/24/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

class CellNodeVideoPlayer: CellNode {
    let player = ASVideoNode()
    var media: Movie
    
    init(media: Movie, didLoad: ((CellNode)->Void)?) {
        self.media = media
        super.init(didLoad: didLoad)
        player.url = media.poster
        player.placeholderFadeDuration = 2.0
        player.backgroundColor = .black
        player.isUserInteractionEnabled = false
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var ratio: CGFloat = CGFloat(media.width / media.height)
        if media.width <= 0 || media.height <= 0 { ratio = 720 / 1280 }
        let ratioSpec = ASRatioLayoutSpec(ratio: ratio, child: player)
        return ratioSpec
    }
}
