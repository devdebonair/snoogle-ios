//
//  CellNodeMovieMetaInfo.swift
//  snoogle
//
//  Created by Vincent Moore on 9/9/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeMovieMetaInfo: CellNode {
    let INSET_FOR_STACK: CGFloat = 10
    
    let textNodeTitle = ASTextNode()
    let backgroundNode = ASDisplayNode()
    let cellNodeAvatarItem = CellNodeAvatarMeta()
    let cellNodeMoviePoster: CellNodeMoviePoster
    var imageNodeLogo: ASNetworkImageNode {
        return self.cellNodeAvatarItem.imageNode
    }
    var textNodeDomain: ASTextNode {
        return self.cellNodeAvatarItem.textNodeTitle
    }
    var textNodeAuthor: ASTextNode {
        return self.cellNodeAvatarItem.textNodeSubtitle
    }
    var imageNodePlay: ASImageNode {
        return self.cellNodeMoviePoster.imageNodePlay
    }
    
    init(photo: Photo, didLoad: ((CellNode) -> Void)? = nil) {
        self.cellNodeMoviePoster = CellNodeMoviePoster(photo: photo)
        super.init(didLoad: didLoad)
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackLayout = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 12.0,
            justifyContent: .start,
            alignItems: .start,
            children: [
                cellNodeAvatarItem,
                textNodeTitle,
                cellNodeMoviePoster])
        let insetForStack = UIEdgeInsets(top: INSET_FOR_STACK, left: INSET_FOR_STACK, bottom: INSET_FOR_STACK, right: INSET_FOR_STACK)
        let insetLayout = ASInsetLayoutSpec(insets: insetForStack, child: stackLayout)
        let backgroundLayout = ASBackgroundLayoutSpec(child: insetLayout, background: backgroundNode)
        return backgroundLayout
    }
}
