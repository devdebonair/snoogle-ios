//
//  CoverTransition.swift
//  snoogle
//
//  Created by Vincent Moore on 6/21/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class CoverTransition: Transition {
    
    private let overlayNode = ASDisplayNode()
    private var snapshot: UIView!
    
    var automaticallyManageGesture: Bool = false
    
    override init(duration: TimeInterval = 0.0, delay: TimeInterval = 0.0) {
        super.init(duration: duration, delay: delay)
    }
    
    override func animatePresent(to: UIView, from: UIView, container: UIView, completion: @escaping (Bool) -> Void) {
        if automaticallyManageGesture {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(interactionPanHandler(pan:)))
            to.addGestureRecognizer(pan)
            if let toController = toViewController as? UIGestureRecognizerDelegate {
                pan.delegate = toController
            }
        }
        
        snapshot = from.snapshotView(afterScreenUpdates: true)
        
        container.addSubview(snapshot)
        container.addSubview(to)
        
        from.isHidden = true
        to.frame.origin.x = container.frame.width
        
        UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, options: [.curveEaseOut], animations: {
            let screenPercentage: CGFloat =  0.1
            self.snapshot.frame.origin.x = 0 - (container.frame.width * screenPercentage)
            self.snapshot.alpha = 0.50
            to.frame.origin.x = 0
        }) { (success: Bool) in
            completion(success)
        }
    }
    
    override func animateDismiss(to: UIView, from: UIView, container: UIView, completion: @escaping (Bool) -> Void) {
        from.clipsToBounds = false
        from.layer.shadowOffset = CGSize(width: -2.0, height: 0.0)
        from.layer.shadowOpacity = 0.20
        from.layer.shadowRadius = 1.0
        from.layer.shadowPath = UIBezierPath(rect: from.bounds).cgPath
        UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, options: [.curveLinear], animations: {
            self.snapshot.alpha = 1.0
            self.snapshot.frame.origin.x = 0
            from.frame.origin.x = container.frame.width
        }) { (success: Bool) in
            completion(success)
        }
    }
    
    override func animationEnded(_ transitionCompleted: Bool) {
        super.animationEnded(transitionCompleted)
        if let toViewController = toViewController, transitionCompleted, type == .dismiss {
            toViewController.view.isHidden = false
        }
    }
    
    override func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
    
    func interactionPanHandler(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view!.superview!)
        var progress = (translation.x / (pan.view!.frame.width * 0.9))
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch pan.state {
            
        case .began:
            toViewController?.dismiss(animated: true, completion: nil)
            
        case .changed:
            update(progress)
            
        case .cancelled:
            cancel()
            
        case .ended:
            if progress < 0.3 {
                cancel()
            } else if progress > 0.99 {
                // Because of weird bug when user manually drags to 1.0
                finish()
            } else {
                finish()
            }
            
        default:
            return
        }
    }
}
