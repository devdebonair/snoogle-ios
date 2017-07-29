//
//  InsetSectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 7/29/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class InsetSectionController: GenericSectionController {
    init(inset: UIEdgeInsets = .zero) {
        super.init()
        self.inset = inset
        let bottom = self.inset.bottom
        self.inset.bottom = 0
        if isLastSection {
            self.inset.bottom = bottom
        }
    }
}
