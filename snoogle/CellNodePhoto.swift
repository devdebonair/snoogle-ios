//
//  CellNodePhoto.swift
//  snoogle
//
//  Created by Vincent Moore on 12/28/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class CellNodePhoto: ASCellNode {
    
    let photo: ASNetworkImageNode
    
    init(url: URL?) {
        self.photo = ASNetworkImageNode()
        self.photo.url = url
        self.photo.contentMode = .scaleAspectFill
        
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let ratioSpec = ASRatioLayoutSpec(ratio: 1.0, child: photo)
        return ratioSpec
    }
    
}
