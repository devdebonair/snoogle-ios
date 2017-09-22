//
//  NavigationController.swift
//  snoogle
//
//  Created by Vincent Moore on 7/30/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class NavigationController: ASNavigationController {
    
    var transition: Transition? = nil {
        didSet {
            self.transitioningDelegate = transition
        }
    }
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
