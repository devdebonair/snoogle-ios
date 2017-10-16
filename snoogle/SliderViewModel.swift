//
//  SliderViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 10/9/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class SliderViewModel: NSObject, ViewModelElement {
    let slider = UISlider()
    let textNodeLeft = ASTextNode()
    let textNodeRight = ASTextNode()
    var textLeft: String = "" {
        didSet {
            textNodeLeft.attributedText = NSMutableAttributedString(string: textLeft, attributes: [
                NSForegroundColorAttributeName: UIColor.darkText,
                NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)
                ])
        }
    }
    var textRight: String = "255" {
        didSet {
            textNodeRight.attributedText = NSMutableAttributedString(string: textRight, attributes: [
                NSForegroundColorAttributeName: UIColor.darkText,
                NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)
                ])
        }
    }
    var min: Float = 0 {
        didSet {
            slider.minimumValue = min
        }
    }
    var max: Float = 0 {
        didSet {
            slider.maximumValue = max
        }
    }
    
    deinit {
        didChangeValue = nil
    }
    
    var didChangeValue: ((Float) -> Void)? = nil
    
    override init() {
        super.init()
        self.slider.addTarget(self, action: #selector(sliderDidChange(sender:)), for: .valueChanged)
    }
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func cell(index: Int) -> ASCellNode {
        let cell = CellNodeStack()
        cell.inset = UIEdgeInsets(top: 25, left: 20, bottom: 25, right: 20)
        cell.stack.spacing = 15
        cell.backgroundColor = ThemeManager.cellBackground()
        cell.stack.alignContent = .center
        cell.stack.alignItems = .center
        cell.stack.verticalAlignment = .center
        cell.stack.horizontalAlignment = .middle
        let sliderNode = ASDisplayNode { () -> UIView in
            return self.slider
        }
        
        textNodeLeft.style.width = ASDimension(unit: .points, value: 40)
        textNodeRight.style.width = ASDimension(unit: .points, value: 40)
        sliderNode.style.height = ASDimension(unit: .points, value: 20.0)
        
        textNodeLeft.attributedText = NSMutableAttributedString(string: textLeft, attributes: [
            NSForegroundColorAttributeName: UIColor.darkText,
            NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)
        ])
        
        textNodeRight.attributedText = NSMutableAttributedString(string: textRight, attributes: [
            NSForegroundColorAttributeName: UIColor.darkText,
            NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)
        ])
        
        sliderNode.style.flexGrow = 1.0
        
        cell.stack.children?.append(textNodeLeft)
        cell.stack.children?.append(sliderNode)
        cell.stack.children?.append(textNodeRight)
        return cell
    }
    
    func sliderDidChange(sender: UISlider) {
        guard let didChangeValue = didChangeValue else { return }
        didChangeValue(sender.value)
    }
}
