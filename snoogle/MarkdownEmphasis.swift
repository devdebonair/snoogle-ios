//
//  MarkdownEmphasis.swift
//  snoogle
//
//  Created by Vincent Moore on 6/19/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

struct MarkdownEmphasis: MarkdownInlineElement {
    let range: NSRange
    let type: MarkdownInlineType = .emphasis
    var font: UIFont
    
    func getAttributes() -> [String : Any] {
        let originalFontDesc = font.fontDescriptor
        let italicFontDesc = originalFontDesc.withSymbolicTraits(.traitItalic)
        let italicFont = UIFont(descriptor: italicFontDesc!, size: font.pointSize)
        return [NSFontAttributeName: italicFont]
    }
}
