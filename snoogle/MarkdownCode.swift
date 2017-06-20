//
//  MarkdownCode.swift
//  snoogle
//
//  Created by Vincent Moore on 6/19/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

struct MarkdownCode {
    var meta: [MarkdownInlineElement] = [MarkdownInlineElement]()
    var text: String
    var font: UIFont
    var lang: String?
    
    func build() -> NSMutableAttributedString {
        let codeFont =  UIFont(name: "Courier New", size: self.font.pointSize)!
//        let originalFontDesc = codeFont.fontDescriptor
//        let boldFontDesc = originalFontDesc.withSymbolicTraits(.traitMonoSpace)
//        let boldFont = UIFont(descriptor: boldFontDesc!, size: codeFont.pointSize)
        return NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: codeFont])
    }
}
