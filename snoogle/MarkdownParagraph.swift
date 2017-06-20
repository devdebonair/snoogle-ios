//
//  MarkdownParagraph.swift
//  snoogle
//
//  Created by Vincent Moore on 6/19/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

struct MarkdownParagraph: MarkdownBlockElement {
    var meta: [MarkdownInlineElement]
    var text: String
    var font: UIFont
    
    func build() -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: text)
        for var item in meta {
            item.font = font
            attributeString.addAttributes(item.getAttributes(), range: item.range)
        }
        return attributeString
    }
}
