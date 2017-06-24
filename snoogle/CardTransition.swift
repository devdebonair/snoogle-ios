//
//  CardTransitionDelegate.swift
//  CardTransition
//
//  Created by Vincent Moore on 2/20/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class CardTransition: Transition {
    
    private let overlayNode = ASDisplayNode()
    private var snapshot: UIView!
    
    var automaticallyManageGesture: Bool = false
    var overlayAlpha: CGFloat = 0.2
    
    override init(duration: TimeInterval = 0.0, delay: TimeInterval = 0.0) {
        super.init(duration: duration, delay: delay)
        overlayNode.alpha = 0.0
        overlayNode.backgroundColor = .black
        overlayNode.frame = UIScreen.main.bounds
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
        
        fromController.view.isHidden = true
        
        container.addSubview(snapshot)
        container.addSubnode(overlayNode)
        container.addSubview(toController.view)
        
        toController.view.clipsToBounds = false
        toController.view.layer.shadowOffset = CGSize(width: 0.0, height: -1.0)
        toController.view.layer.shadowOpacity = 0.20
        toController.view.layer.shadowRadius = 1.0
        toController.view.layer.shadowPath = UIBezierPath(rect: fromController.view.bounds).cgPath
        
        toController.view.frame.size = CGSize(width: container.frame.width, height: container.frame.height * 0.5)
        toController.view.frame.origin.y = container.frame.height
        
        UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, options: [.curveEaseInOut], animations: {
            toController.view.frame.origin.y = container.frame.height - toController.view.frame.height
            self.overlayNode.alpha = self.overlayAlpha
            let scale: CGFloat = 0.95
            self.snapshot.transform = CGAffineTransform(scaleX: scale, y: scale)
        }) { (success: Bool) in
            completion(success)
        }
    }
    
    override func dismiss(toController: UIViewController, fromController: UIViewController, container: UIView, completion: @escaping (Bool)->Void) {
        UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, options: [.curveEaseInOut], animations: {
            fromController.view.frame.origin.y = container.frame.height
            self.snapshot.transform = .identity
            self.overlayNode.alpha = 0.0
        }) { (success: Bool) in
            completion(success)
        }
    }
    
    override func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
    
    override func animationEnded(_ transitionCompleted: Bool) {
        super.animationEnded(transitionCompleted)
        if let toViewController = toViewController, transitionCompleted, type == .dismiss {
            toViewController.view.isHidden = false
        }
    }
    
    func interactionPanHandler(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view!.superview!)
        var progress = (translation.y / (pan.view!.frame.height))
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        print(progress)
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
