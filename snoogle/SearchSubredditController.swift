//
//  SearchSubredditController.swift
//  snoogle
//
//  Created by Vincent Moore on 7/25/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SearchSubredditController: CollectionController {
    override func viewDidLoad() {
        super.viewDidLoad()
        node.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
    }
    
    func updateModels(models: [IGListDiffable]) {
        self.models = models
        self.adapter.performUpdates(animated: true, completion: nil)
    }
    
    override func sectionController() -> GenericSectionController {
        let sectionController = GenericSectionController()
        return sectionController
    }}
