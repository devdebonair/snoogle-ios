//
//  CellNodeMediaAlbum.swift
//  snoogle
//
//  Created by Vincent Moore on 1/10/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeMediaAlbum: CellNode, ASCollectionDelegate {
    
    var media: [MediaElement]
    let slider: NodeSlide
    let models: [ViewModelElement]
    var delegate: CellNodeMediaDelegate? = nil
    var flowLayout: UICollectionViewFlowLayout {
        return slider.flowLayout
    }
    var collectionNode: ASCollectionNode {
        return slider.collectionNode
    }
    
    init(media: [MediaElement]) {
        self.media = media
        self.models = [AlbumSlideViewModel(media: media, isStyled: (media.count != 1))]
        self.slider = NodeSlide(models: models)
        
        super.init()
        
        automaticallyManagesSubnodes = true
        slider.collectionNode.delegate = self
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else { return }
//        delegate.didTapMedia(selectedIndex: indexPath.row)
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if media.count == 1, let mediaItem = media.first {
            let ratio = CGFloat(mediaItem.height/mediaItem.width)
            let ratioSpec = ASRatioLayoutSpec(ratio: ratio, child: slider)
            return ratioSpec
        }
        slider.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 300.0)
        return ASInsetLayoutSpec(insets: .zero, child: slider)
    }
}
