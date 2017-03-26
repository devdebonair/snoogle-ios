//
//  String+Integer+Subscript.swift
//  snoogle
//
//  Created by Vincent Moore on 1/1/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation

extension String {
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    // for convenience we should include String return
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: r.lowerBound)
        let end = self.index(self.startIndex, offsetBy: r.upperBound)
        return self[start..<end]
    }
}
