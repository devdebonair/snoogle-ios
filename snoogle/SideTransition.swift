//
//  SideTransition.swift
//  snoogle
//
//  Created by Vincent Moore on 6/24/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class SlideTransition: Transition {
    
    var isInteractive: Bool = false
    var menuController: UIViewController? = nil
    var mainController: UIViewController? = nil {
        didSet {
            guard let mainController = mainController else { return }
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(interactionPanHandlerForPresentation(pan:)))
            mainController.view.addGestureRecognizer(panGesture)
        }
    }
    
    private let overlayNode = ASDisplayNode()
    private var snapshot: UIView!

    private var offsetMenuModifier: CGFloat = 0.10
    private var offsetMainModifier: CGFloat = 0.10
    
    override func animatePresent(to: UIView, from: UIView, container: UIView, completion: @escaping (Bool) -> Void) {
        snapshot = from.snapshotView(afterScreenUpdates: true)
        
        if !isInteractive {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(interactionPanHandler(pan:)))
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOverlay))
            snapshot.addGestureRecognizer(pan)
            snapshot.addGestureRecognizer(tap)
        }
        
        overlayNode.backgroundColor = .white
        overlayNode.frame = from.frame
        overlayNode.clipsToBounds = false
        overlayNode.layer.shadowOffset = CGSize(width: -1.0, height: 0.0)
        overlayNode.layer.shadowOpacity = 0.20
        overlayNode.layer.shadowRadius = 3.0
        overlayNode.layer.shadowPath = UIBezierPath(rect: to.bounds).cgPath
        
        to.frame.origin.x = 0 - (container.frame.width * self.offsetMenuModifier)
        
        container.addSubview(to)
        container.addSubnode(overlayNode)
        container.addSubview(snapshot)
        
        // +1 to remove black line between to and from controllers and position to under from
        let width: CGFloat = container.frame.width - (container.frame.width * offsetMenuModifier) + 1
        to.frame.size = CGSize(width: width, height: container.frame.height)
        
        UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, options: [.curveEaseOut], animations: {
            let percentageOfScreen: CGFloat = (container.frame.width * self.offsetMenuModifier)
            self.snapshot.frame.origin.x = container.frame.width - percentageOfScreen
            self.overlayNode.frame.origin.x = container.frame.width - percentageOfScreen
            to.frame.origin.x = 0
            self.snapshot.alpha = 0.2
        }) { (success) in
            completion(success)
        }
    }
    
    override func animateDismiss(to: UIView, from: UIView, container: UIView, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, options: [.curveEaseOut], animations: {
            self.snapshot.frame.origin.x = 0.0
            self.overlayNode.frame = self.snapshot.frame
            self.snapshot.alpha = 1.0
            from.frame.origin.x = 0 - (container.frame.width * self.offsetMenuModifier)
        }) { (success) in
            completion(success)
        }
    }
    
    override func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
    
    override func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let _ = mainController, let _ = menuController else { return nil }
        return self
    }
    
    func didTapOverlay() {
        guard let toViewController = self.toViewController else { return }
        toViewController.dismiss(animated: true, completion: nil)
        finish()
    }
    
    func interactionPanHandlerForPresentation(pan: UIPanGestureRecognizer) {
        guard let mainController = mainController, let menuController = menuController else { return }
        let translation = pan.translation(in: pan.view!.superview!)
        var progress = (translation.x / (pan.view!.frame.width * 0.9))
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        switch pan.state {
            
        case .began:
            menuController.transitioningDelegate = self
            mainController.present(menuController, animated: true, completion: nil)
            
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
    
    func interactionPanHandler(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view!.window!)
        let translationX = translation.x >= 0 ? translation.x : (translation.x * -1)
        var progress = (translationX / (UIScreen.main.bounds.width * 0.9))
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
