//
//  UISearchBar+FieldColor.swift
//  snoogle
//
//  Created by Vincent Moore on 10/2/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    // https://stackoverflow.com/questions/13817330/how-to-change-inside-background-color-of-uisearchbar-component-on-ios
    private func getViewElement<T>(type: T.Type) -> T? {
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func setTextField(color: UIColor) {
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                
            case .prominent, .default:
                textField.backgroundColor = color
            }
        }
    }
}
