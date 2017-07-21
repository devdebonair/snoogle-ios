//
//  FrameTransition.swift
//  snoogle
//
//  Created by Vincent Moore on 7/20/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class FrameTransition: Transition {
    let origin: CGRect
    let destination: CGRect
    let node: ASDisplayNode
    
    private var snapshot: UIView!
    var scaleValue: CGFloat = 0.95
    
    init(duration: TimeInterval, delay: TimeInterval, origin: CGRect, destination: CGRect, node: ASDisplayNode) {
        self.origin = origin
        self.destination = destination
        self.node = node
        super.init(duration: duration, delay: delay)
    }
    
    override func animatePresent(to: UIView, from: UIView, container: UIView, completion: @escaping (Bool) -> Void) {
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(interactionPanHandler(pan:)))
        to.addGestureRecognizer(pan)
        
        snapshot = from.snapshotView(afterScreenUpdates: true)
        let nodeSnapshot = self.node.view.snapshotView(afterScreenUpdates: true)!
        
        from.isHidden = true
        
        container.addSubview(snapshot)
        container.addSubview(nodeSnapshot)
        container.addSubview(to)
        
        to.alpha = 0.0
        
        to.frame = container.frame
        snapshot.frame = container.frame
        nodeSnapshot.frame = origin
        
        node.isHidden = true
        
        UIView.animate(withDuration: self.animationDuration * 0.2, delay: 0.0, options: [.curveLinear], animations: {
            self.snapshot.alpha = 0.0
            self.snapshot.transform = CGAffineTransform(scaleX: self.scaleValue, y: self.scaleValue)
        }, completion: nil)
        
        UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [.curveLinear], animations: {
            nodeSnapshot.frame = self.destination
            nodeSnapshot.center = container.center
        }) { (success) in
            UIView.animate(withDuration: 0.2, animations: {
                to.alpha = 1.0
            }, completion: { (success) in
                nodeSnapshot.removeFromSuperview()
                completion(success)
            })
        }
    }

    override func animateDismiss(to: UIView, from: UIView, container: UIView, completion: @escaping (Bool) -> Void) {
        node.isHidden = false
        UIView.animate(withDuration: self.animationDuration, delay: 0.0, options: [.curveLinear], animations: {
            from.frame.origin.y = container.frame.height
            self.snapshot.transform = .identity
            self.snapshot.alpha = 1.0
        }) { (success) in
            to.isHidden = false
            
            // TODO: Check why animation is returning false when updated to 1.0
            completion(true)
        }
    }
    
    override func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
    
    override func animationEnded(_ transitionCompleted: Bool) {
        super.animationEnded(transitionCompleted)
    }
    
    func interactionPanHandler(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view!.superview!)
        var progress = (translation.y / (pan.view!.frame.height * 0.4))
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
                
        switch pan.state {
            
        case .began:
            if let toViewController = toViewController {
                toViewController.dismiss(animated: true, completion: nil)
            }
            
        case .changed:
            update(progress)
            
        case .cancelled:
            cancel()
            
        case .ended:
            if progress < 0.16 {
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
