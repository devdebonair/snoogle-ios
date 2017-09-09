//
//  CellNodeMoviePoster.swift
//  snoogle
//
//  Created by Vincent Moore on 9/8/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeMoviePoster: CellNode {
    let mediaNode: CellNodeMedia
    let imageNodePlay = ASImageNode()
    let photo: Photo
    
    init(photo: Photo, didLoad: ((CellNode) -> Void)? = nil) {
        self.photo = photo
        self.mediaNode = CellNodeMedia(media: photo)
        super.init(didLoad: didLoad)
        self.imageNodePlay.image = #imageLiteral(resourceName: "play")
        self.imageNodePlay.contentMode = .scaleAspectFit
        self.imageNodePlay.style.width = ASDimension(unit: .fraction, value: 0.35)
        self.imageNodePlay.style.height = ASDimension(unit: .fraction, value: 0.35)
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let centerLayout = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: imageNodePlay)
        let background = ASBackgroundLayoutSpec(child: centerLayout, background: mediaNode)
        return ASRatioLayoutSpec(ratio: 720/1280, child: background)
    }
}
