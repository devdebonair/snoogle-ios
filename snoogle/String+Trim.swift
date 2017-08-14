//
//  String+Trim.swift
//  snoogle
//
//  Created by Vincent Moore on 8/14/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation

extension String {
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func trimmedLowercase() -> String {
        return self.trimmed().lowercased()
    }
}
