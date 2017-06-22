//
//  Transition.swift
//  CardTransition
//
//  Created by Vincent Moore on 2/22/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class Transition: UIPercentDrivenInteractiveTransition, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate {
    
    enum TransitionType: Int {
        case present = 0
        case dismiss = 1
    }
    
    let animationDuration: TimeInterval
    let animationDelay: TimeInterval
    var type: TransitionType = .present
    var isAnimating = false
    
    var toViewController: UIViewController? = nil
    var fromViewController: UIViewController? = nil
    
    init(duration: TimeInterval = 0.0, delay: TimeInterval = 0.0) {
        self.animationDuration = duration
        self.animationDelay = delay
        super.init()
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        type = .dismiss
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        type = .present
        return self
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard  let toController = transitionContext.viewController(forKey: .to), let fromController = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        self.toViewController = toController
        self.fromViewController = fromController
        
        switch type {
        case .present:
            present(toController: toController, fromController: fromController, container: container) { (success: Bool) in
                if transitionContext.transitionWasCancelled {
                    transitionContext.completeTransition(false)
                } else {
                    transitionContext.completeTransition(success)
                }
            }
        case .dismiss:
            dismiss(toController: toController, fromController: fromController, container: container) { (success: Bool) in
                if transitionContext.transitionWasCancelled {
                    transitionContext.completeTransition(false)
                } else {
                    transitionContext.completeTransition(success)
                }
            }
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        if !transitionCompleted {
            if type == TransitionType.dismiss {
                type = TransitionType.present
            } else {
                type = TransitionType.dismiss
            }
        }
    }
    
    func present(toController: UIViewController, fromController: UIViewController, container: UIView, completion: @escaping (Bool)->Void) {
        completion(true)
    }
    
    func dismiss(toController: UIViewController, fromController: UIViewController, container: UIView, completion: @escaping (Bool)->Void) {
        completion(true)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
