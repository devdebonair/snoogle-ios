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
    
    var transition: Transition!
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        transition = CoverTransition(duration: 0.4, delay: 0.1)
    }
    
    override func didSelectItem(at index: Int) {
        if let viewController = self.viewController {
            if let transition = transition as? CoverTransition {
                transition.automaticallyManageGesture = true
            }
            let articleController = ArticleCollectionController(id: model.id)
            let controller = ASNavigationController(rootViewController: articleController)
            controller.isToolbarHidden = true
            controller.isNavigationBarHidden = true
            controller.transitioningDelegate = transition
            controller.delegate = transition
            viewController.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
    
    func popController() {
        if let viewController = self.viewController {
            viewController.navigationController?.popViewController(animated: true)
        }
    }
}
