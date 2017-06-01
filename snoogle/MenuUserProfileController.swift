//
//  MenuUserProfileController.swift
//  snoogle
//
//  Created by Vincent Moore on 5/31/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class MenuUserProfileController: MenuItemCollectionController {
    override init() {
        super.init()
        self.models = [MenuUserProfileViewModel()]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return MenuUserProfileSectionController()
    }
}
