//
//  CellNodeActivity.swift
//  snoogle
//
//  Created by Vincent Moore on 8/5/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

class CellNodeActivity: CellNode {
    let textNodeLabel = ASTextNode()
    let textNodeProgress = ASTextNode()
    let progressIndicator = UIProgressView()
    lazy var nodeProgressIndicator = ASDisplayNode { () -> UIView in
        return self.progressIndicator
    }
    
    func set(progress: Float, animated: Bool = false) {
        progressIndicator.setProgress(progress, animated: animated)
    }
    
    func set(trackColor color: UIColor) {
        progressIndicator.trackTintColor = color
    }
    
    func set(progressColor color: UIColor) {
        progressIndicator.progressTintColor = color
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackLabels = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .stretch, children: [textNodeLabel, textNodeProgress])
        let stackContainer = ASStackLayoutSpec(direction: .vertical, spacing: 7.0, justifyContent: .start, alignItems: .start, children: [stackLabels, nodeProgressIndicator])
        nodeProgressIndicator.style.width = ASDimension(unit: .fraction, value: 1.0)
        nodeProgressIndicator.style.height = ASDimension(unit: .points, value: 3.0)
        stackLabels.style.width = ASDimension(unit: .fraction, value: 1.0)
        return stackContainer
    }
}
