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
    private var cancelCell: Header!
    private var card: ASDisplayNode!
    
    var automaticallyManageGesture: Bool = false
    var overlayAlpha: CGFloat = 0.9
    var cardCornerRadius: CGFloat = 10.0
    var cardHeight: CGFloat = 0.8
    
    override init(duration: TimeInterval) {
        super.init(duration: duration)
        overlayNode.alpha = 0.0
        overlayNode.backgroundColor = .black
        overlayNode.frame = UIScreen.main.bounds
    }

    override func present(toController: UIViewController, fromController: UIViewController, container: UIView, completion: @escaping (Bool) -> Void) {
        guard let toController = toController as? ASViewController<ASDisplayNode>, let fromController = fromController as? ASViewController<ASDisplayNode> else { return completion(false) }
        
        if automaticallyManageGesture {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(interactionPanHandler(pan:)))
            toController.node.view.addGestureRecognizer(pan)
            if let toController = toController as? UIGestureRecognizerDelegate {
                pan.delegate = toController
                
            }
        }
        if let navigation = fromController.navigationController {
            snapshot = navigation.view.snapshotView(afterScreenUpdates: true)
        } else {
            snapshot = fromController.node.view.snapshotView(afterScreenUpdates: false)
        }
        snapshot.layer.cornerRadius = cardCornerRadius
        snapshot.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeCard(gesture:)))
        cancelCell = Header(text: "Cancel")
        cancelCell.backgroundColor = toController.node.backgroundColor
        cancelCell.view.addGestureRecognizer(tapGesture)
        
        card = ASDisplayNode()
        card.clipsToBounds = true
        card.layer.cornerRadius = cardCornerRadius
        
        fromController.node.isHidden = true
        fromController.navigationController?.setToolbarHidden(true, animated: false)
        fromController.navigationController?.setNavigationBarHidden(true, animated: false)
        
        card.addSubnode(toController.node)
        card.addSubnode(cancelCell)
        
        container.addSubview(snapshot)
        container.addSubnode(overlayNode)
        container.addSubnode(card)
        
        card.frame.size = CGSize(width: container.frame.width, height: container.frame.height * cardHeight)
        cancelCell.frame.size = CGSize(width: card.frame.width, height: 62)
        toController.node.frame.size = CGSize(width: card.frame.width, height: card.frame.height - cancelCell.frame.height)
        
        card.frame.origin.y = container.frame.height
        cancelCell.frame.origin.y = toController.node.frame.origin.y + toController.node.frame.height
        
        UIView.animate(withDuration: self.animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.snapshot.center.x = container.center.x
            
            self.card.frame.origin.y = container.frame.height - self.card.frame.height
//            self.snapshot.frame.origin.y = self.card.frame.origin.y - 120
            
            self.overlayNode.alpha = self.overlayAlpha
            
        }) { (success: Bool) in
            completion(success)
        }
    }
    
    override func dismiss(toController: UIViewController, fromController: UIViewController, container: UIView, completion: @escaping (Bool)->Void) {
        let overlayAlpha: CGFloat = 0.0
        UIView.animate(withDuration: self.animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.snapshot.frame.size = container.frame.size
            self.snapshot.frame.origin = .zero
            
            self.card.frame.origin.y = UIScreen.main.bounds.height
            
            self.overlayNode.alpha = overlayAlpha
            
        }) { (success: Bool) in
            toController.navigationController?.setToolbarHidden(false, animated: false)
            toController.navigationController?.setNavigationBarHidden(false, animated: false)
            completion(success)
        }
    }
    
    override func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
    
    func closeCard(gesture: UITapGestureRecognizer) {
        if let fromViewController = fromViewController, type == .present {
            fromViewController.dismiss(animated: true, completion: nil)
            finish()
        }
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
