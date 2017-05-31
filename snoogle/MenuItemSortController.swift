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
    
    init(model: IGListDiffable) {
        super.init()
        self.models = [model]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
