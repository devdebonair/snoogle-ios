//
//  MarkdownBlockQuote.swift
//  snoogle
//
//  Created by Vincent Moore on 6/19/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

struct MarkdownBlockQuote: MarkdownBlockElement {
    var meta: [MarkdownInlineElement]
    var text: String
    var font: UIFont
    
    func build() -> NSMutableAttributedString {
        let originalFontDesc = font.fontDescriptor
        let italicFontDesc = originalFontDesc.withSymbolicTraits(.traitItalic)
        let italicFont = UIFont(descriptor: italicFontDesc!, size: font.pointSize)
        return NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: italicFont])
    }
}
