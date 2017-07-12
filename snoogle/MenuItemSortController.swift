//
//  MenuItemSortController.swift
//  snoogle
//
//  Created by Vincent Moore on 5/31/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit

class MenuItemSortController: MenuItemCollectionController {
    override init() {
        super.init()
        self.models = [SubmissionSortViewModel()]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
