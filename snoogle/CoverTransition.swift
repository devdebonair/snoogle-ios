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
    
    override func present(toController: UIViewController, fromController: UIViewController, container: UIView, completion: @escaping (Bool) -> Void) {
        if automaticallyManageGesture {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(interactionPanHandler(pan:)))
            toController.view.addGestureRecognizer(pan)
            if let toController = toController as? UIGestureRecognizerDelegate {
                pan.delegate = toController
            }
        }
        
        if let navigation = fromController.navigationController {
            snapshot = navigation.view.snapshotView(afterScreenUpdates: true)
        } else {
            snapshot = fromController.view.snapshotView(afterScreenUpdates: false)
        }
        
        container.addSubview(snapshot)
        container.addSubview(toController.view)
        
        fromController.view.isHidden = true
        toController.view.frame.origin.x = container.frame.width
        
        UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, options: [.curveEaseOut], animations: {
            let screenPercentage: CGFloat =  0.01
            self.snapshot.center.x = container.center.x + (container.frame.width * screenPercentage)
            self.snapshot.alpha = 0.50
            let scale: CGFloat = 0.93
            self.snapshot.transform = CGAffineTransform(scaleX: scale, y: scale)
            toController.view.frame.origin.x = 0
        }) { (success: Bool) in
            completion(success)
        }
    }
    
    override func dismiss(toController: UIViewController, fromController: UIViewController, container: UIView, completion: @escaping (Bool) -> Void) {
        fromController.view.clipsToBounds = false
        fromController.view.layer.shadowOffset = CGSize(width: -8.0, height: 0.0)
        fromController.view.layer.shadowOpacity = 0.20
        fromController.view.layer.shadowRadius = 1.0
        fromController.view.layer.shadowPath = UIBezierPath(rect: fromController.view.bounds).cgPath
        UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, options: [.curveLinear], animations: {
            self.snapshot.transform = .identity
            self.snapshot.alpha = 1.0
            self.snapshot.center.x = container.center.x
            fromController.view.frame.origin.x = container.frame.width
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
