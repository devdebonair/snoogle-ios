//
//  ASButtonNode+Animate.swift
//  snoogle
//
//  Created by Vincent Moore on 3/28/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

extension ASButtonNode {
    func animate(duration: CGFloat = 0.6, image: UIImage? = nil, color: UIColor, title: NSAttributedString? = nil) {
        UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5.0, options: [.curveEaseIn], animations: {
            self.view.transform = CGAffineTransform(scaleX: 3, y: 3)
            self.setImage(nil, for: [])
            self.setImage(image, for: [])
            self.setAttributedTitle(title, for: [])
            self.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(color)
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
}
