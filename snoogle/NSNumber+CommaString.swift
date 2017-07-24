//
//  NSNumber+CommaString.swift
//  snoogle
//
//  Created by Vincent Moore on 7/23/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation

extension NSNumber {
    func convertToCommaWithString() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: self)
    }
}
