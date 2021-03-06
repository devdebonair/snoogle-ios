//
//  CellNodeMediaPage.swift
//  snoogle
//
//  Created by Vincent Moore on 7/20/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeMediaPage: CellNode {
    let media: MediaElement
    let cellMedia: CellNodeMedia
    
    init(media: MediaElement) {
        self.media = media
        self.cellMedia = CellNodeMedia(media: media)
        super.init()
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASCenterLayoutSpec(centeringOptions: [.Y], sizingOptions: [], child: cellMedia)
    }
}
