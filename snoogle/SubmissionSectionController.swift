//
//  SubmissionSectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 3/26/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class SubmissionSectionController: SectionController<PostViewModel> {
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    override func didSelectItem(at index: Int) {
        if let viewController = self.viewController {
            let controller = ArticleCollectionController(id: model.id)
            viewController.navigationController?.delegate = nil
            viewController.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func popController() {
        if let viewController = self.viewController {
            viewController.navigationController?.popViewController(animated: true)
        }
    }
    
}
