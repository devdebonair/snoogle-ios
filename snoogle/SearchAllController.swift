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
        node.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
    }
    
    func updateModels(models: [IGListDiffable]) {
        self.models = models
        self.adapter.performUpdates(animated: true, completion: nil)
    }
    
    override func sectionController() -> GenericSectionController {
        let sectionController = GenericSectionController()
        sectionController.inset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        return sectionController
    }
}
