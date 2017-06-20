//
//  ArticleContent.swift
//  snoogle
//
//  Created by Vincent Moore on 6/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

struct ArticleContent {
    
    var font = UIFont.systemFont(ofSize: 14)
    let content: NSMutableAttributedString
    
    init(text: String) {
        content = NSMutableAttributedString(string: text)
    }
    
    func setLink(url: String, start: Int, end: Int) {
        let range = NSRange(location: start, length: end)
        content.addAttribute(NSLinkAttributeName, value: url, range: range)
    }
    
    func setEmphasis(start: Int, end: Int) {
        // TODO: Fix force unwrap for font conversion
        let range = NSRange(location: start, length: end)
        let originalFontDesc = font.fontDescriptor
        let italicFontDesc = originalFontDesc.withSymbolicTraits(.traitItalic)
        let italicFont = UIFont(descriptor: italicFontDesc!, size: 14)
        let attribute = [NSFontAttributeName: italicFont]
        content.setAttributes(attribute, range: range)
    }
    
    func setStrong(start: Int, end: Int) {
        // TODO: Fix force unwrap for font conversion
        let range = NSRange(location: start, length: end)
        let originalFontDesc = font.fontDescriptor
        let boldFontDesc = originalFontDesc.withSymbolicTraits(.traitBold)
        let boldFont = UIFont(descriptor: boldFontDesc!, size: 14)
        let attribute = [NSFontAttributeName: boldFont]
        content.setAttributes(attribute, range: range)
    }
    
    func setInlineCode(start: Int, end: Int) {
        let range = NSRange(location: start, length: end)
        let attribute = [NSBackgroundColorAttributeName: UIColor.lightGray]
        content.setAttributes(attribute, range: range)
    }
    
    func setDelete(start: Int, end: Int) {
        let range = NSRange(location: start, length: end)
        let attribute = [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        content.setAttributes(attribute, range: range)
    }
    
    func setCode() {
        
    }
    
    func setBlockQuoute() {
        setEmphasis(start: 0, end: content.string.characters.count)
    }
}
