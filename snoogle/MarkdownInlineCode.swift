//
//  MarkdownInlineCode.swift
//  snoogle
//
//  Created by Vincent Moore on 6/19/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

struct MarkdownInlineCode: MarkdownInlineElement {
    let range: NSRange
    let type: MarkdownInlineType = .inlineCode
    var font: UIFont
    
    func getAttributes() -> [String : Any] {
        return [
            NSBackgroundColorAttributeName: UIColor.lightGray,
            NSFontAttributeName: UIFont(name: "Courier New", size: font.pointSize)!
        ]
    }
}
