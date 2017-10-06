//
//  SearchAllController.swift
//  snoogle
//
//  Created by Vincent Moore on 7/22/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SearchAllController: CollectionController {
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = [.top]
        extendedLayoutIncludesOpaqueBars = true
        let bottomInset: CGFloat = (self.navigationController?.toolbar.frame.height ?? 0) + self.bottomLayoutGuide.length + 200
        collectionNode.view.contentInset = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: bottomInset, right: 0)
    }
    
    func updateModels(models: [IGListDiffable]) {
        self.models = models
        self.adapter.performUpdates(animated: true, completion: nil)
    }
    
    override func sectionController() -> GenericSectionController {
        let sectionController = InsetSectionController(inset: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
        return sectionController
    }
}
