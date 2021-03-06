//
//  CellNodeTextSwitch.swift
//  snoogle
//
//  Created by Vincent Moore on 8/18/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

class CellNodeTextSwitch: CellNode {
    let textNode = ASTextNode()
    lazy var switchView: UISwitch = {
        return UISwitch()
    }()
    lazy var switchNode = ASDisplayNode { () -> UIView in
        return self.switchView
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .spaceBetween,
            alignItems: .center,
            children: [textNode])
        DispatchQueue.main.async {
            stack.children?.append(self.switchNode)
        }
        switchNode.style.preferredSize = CGSize(width: 50.0, height: 30.0)
        stack.style.width = ASDimension(unit: .fraction, value: 1.0)
        return stack
    }
}
