//
//  ColorPickerSlideController.swift
//  snoogle
//
//  Created by Vincent Moore on 10/10/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import ChameleonFramework

class ColorPickerSlideController: CollectionController {
    let colorNode = ASDisplayNode()
    
    var modelRed: SliderViewModel? = nil
    var modelBlue: SliderViewModel? = nil
    var modelGreen: SliderViewModel? = nil
    
    var didChangeColor: ((UIColor)->Void)? = nil
    
    deinit {
        didChangeColor = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.node.addSubnode(colorNode)
        self.collectionNode.view.bounces = false
        self.colorNode.frame.origin = .zero
        self.colorNode.frame.size = CGSize(width: self.node.frame.width, height: self.node.frame.width)
        self.collectionNode.frame.origin.y = self.colorNode.frame.height
        self.collectionNode.frame.size.height = self.node.frame.height - self.colorNode.frame.height
        if let backgroundColor = self.colorNode.backgroundColor {
            let color = CIColor(color: backgroundColor)
            let red = buildModel(value: Float(color.red), title: "Red")
            let green = buildModel(value: Float(color.green), title: "Green")
            let blue = buildModel(value: Float(color.blue), title: "Blue")
            
            red.didChangeValue = { [weak self] (value) in
                guard let backgroundColor = self?.colorNode.backgroundColor else { return }
                let color = CIColor(color: backgroundColor)
                let newColor = UIColor(red: CGFloat(value), green: color.green, blue: color.blue, alpha: 1.0)
                red.slider.minimumTrackTintColor = newColor
                green.slider.minimumTrackTintColor = newColor
                blue.slider.minimumTrackTintColor = newColor
                red.slider.maximumTrackTintColor = newColor.withAlphaComponent(0.2)
                green.slider.maximumTrackTintColor = newColor.withAlphaComponent(0.2)
                blue.slider.maximumTrackTintColor = newColor.withAlphaComponent(0.2)
                red.textRight = "\(Int(value * 255))"
                self?.colorNode.backgroundColor = newColor
            }
            green.didChangeValue = { [weak self] (value) in
                guard let backgroundColor = self?.colorNode.backgroundColor else { return }
                let color = CIColor(color: backgroundColor)
                let newColor = UIColor(red: color.red, green: CGFloat(value), blue: color.blue, alpha: 1.0)
                red.slider.minimumTrackTintColor = newColor
                green.slider.minimumTrackTintColor = newColor
                blue.slider.minimumTrackTintColor = newColor
                red.slider.maximumTrackTintColor = newColor.withAlphaComponent(0.2)
                green.slider.maximumTrackTintColor = newColor.withAlphaComponent(0.2)
                blue.slider.maximumTrackTintColor = newColor.withAlphaComponent(0.2)
                green.textRight = "\(Int(value * 255))"
                self?.colorNode.backgroundColor = newColor
            }
            blue.didChangeValue = { [weak self] (value) in
                guard let backgroundColor = self?.colorNode.backgroundColor else { return }
                let color = CIColor(color: backgroundColor)
                let newColor = UIColor(red: color.red, green: color.green, blue: CGFloat(value), alpha: 1.0)
                red.slider.minimumTrackTintColor = newColor
                green.slider.minimumTrackTintColor = newColor
                blue.slider.minimumTrackTintColor = newColor
                red.slider.maximumTrackTintColor = newColor.withAlphaComponent(0.2)
                green.slider.maximumTrackTintColor = newColor.withAlphaComponent(0.2)
                blue.slider.maximumTrackTintColor = newColor.withAlphaComponent(0.2)
                blue.textRight = "\(Int(value * 255))"
                self?.colorNode.backgroundColor = newColor
            }
            
            self.models = [red, green, blue]
            self.modelRed = red
            self.modelGreen = green
            self.modelBlue = blue
        }
        self.updateModels()
    }
    
    func buildModel(value: Float = 0, title: String = "") -> SliderViewModel {
        let model = SliderViewModel()
        model.textLeft = title
        model.min = 0
        model.max = 1
        if let backgroundColor = self.colorNode.backgroundColor {
            model.slider.minimumTrackTintColor = backgroundColor
            model.slider.maximumTrackTintColor = backgroundColor.withAlphaComponent(0.2)
        }
        model.slider.value = value
        return model
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let didChangeColor = didChangeColor, let color = colorNode.backgroundColor else { return }
        didChangeColor(color)
    }
}
