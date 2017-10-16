//
//  ColorPickerController.swift
//  snoogle
//
//  Created by Vincent Moore on 10/6/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

class ColorPickerController: ASViewController<ASDisplayNode> {
    
    let segmentControl = UISegmentedControl()
    let backgroundNode = ASDisplayNode()
    lazy var segmentNode: ASDisplayNode = {
        return ASDisplayNode(viewBlock: { () -> UIView in
            return self.segmentControl
        })
    }()
    
    var color: UIColor = .white {
        didSet {
            self.backgroundNode.backgroundColor = color
        }
    }
    
    var titleCache: String = ""
    
    var previousLocationX: CGFloat = 0.0
    
    enum RGB: Int {
        case red = 0
        case green = 1
        case blue = 2
    }
    
    init() {
        super.init(node: ASDisplayNode())
        segmentControl.insertSegment(withTitle: "R", at: RGB.red.rawValue, animated: false)
        segmentControl.insertSegment(withTitle: "G", at: RGB.green.rawValue, animated: false)
        segmentControl.insertSegment(withTitle: "B", at: RGB.blue.rawValue, animated: false)
    }
    
    func didPan(sender: UIPanGestureRecognizer) {
        guard let rgbType = RGB(rawValue: self.segmentControl.selectedSegmentIndex) else { return }
        let translation = sender.translation(in: self.node.view)
        let location = sender.location(in: self.node.view)
        
        switch sender.state {
        case .began:
            self.previousLocationX = location.x
            self.titleCache = self.segmentControl.titleForSegment(at: rgbType.rawValue) ?? ""

        case .changed:
            let color = CIColor(color: self.color)
            var colorValueToChange: CGFloat = 0.0
            
            switch rgbType {
            case .red:
                colorValueToChange = color.red
            case .green:
                colorValueToChange = color.green
            case .blue:
                colorValueToChange = color.blue
            }
            
            let step = location.x >= previousLocationX ? 1 : -1
            let value = max(min(255, Int(colorValueToChange * 255) + step), 0)
            
            var currentRedValue: CGFloat = CGFloat(color.red * 255) / 255
            var currentBlueValue: CGFloat = CGFloat(color.blue * 255) / 255
            var currentGreenValue: CGFloat = CGFloat(color.green * 255) / 255
            
            switch rgbType {
            case .red:
                currentRedValue = CGFloat(value) / 255
            case .green:
                currentGreenValue = CGFloat(value) / 255
            case .blue:
                currentBlueValue = CGFloat(value) / 255
            }
            
            self.color = UIColor(red: currentRedValue, green: currentGreenValue, blue: currentBlueValue, alpha: 1.0)
            self.segmentControl.setTitle("\(value)", forSegmentAt: rgbType.rawValue)
            self.previousLocationX = location.x
        case .ended:
            self.segmentControl.setTitle(self.titleCache, forSegmentAt: rgbType.rawValue)
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.node.addSubnode(backgroundNode)
        self.node.addSubnode(segmentNode)
        
        self.backgroundNode.frame = self.node.frame
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        self.node.view.addGestureRecognizer(pan)
        
        self.segmentNode.frame.size = CGSize(width: 300, height: 55)
        self.segmentNode.position = self.backgroundNode.position
        self.segmentNode.frame.origin.y = self.backgroundNode.frame.height - self.segmentNode.frame.height - (self.node.frame.height * 0.1)
        self.segmentNode.borderWidth = 2.0
        self.segmentNode.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        self.segmentNode.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        self.segmentNode.backgroundColor = .white
        self.segmentNode.cornerRadius = 25
        self.segmentNode.clipsToBounds = true
        
        self.segmentControl.setTitleTextAttributes(
            [NSForegroundColorAttributeName: UIColor.darkText,
             NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold)], for: [])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
