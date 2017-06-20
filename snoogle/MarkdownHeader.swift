//
//  MarkdownHeader.swift
//  snoogle
//
//  Created by Vincent Moore on 6/20/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

struct MarkdownHeader: MarkdownBlockElement {
    var meta: [MarkdownInlineElement]
    var text: String
    var font: UIFont
    var depth: Int
    
    func build() -> NSMutableAttributedString {
        let size: CGFloat = 18.0
//        switch depth {
//        case 1:
//            size = 27.0
//        case 2:
//            size = 22.0
//        case 3:
//            size = 18.0
//        case 4:
//            size = 13.5
//        case 5:
//            size = 10.0
//        case 6:
//            size = 9.0
//        default:
//            size = font.pointSize
//        }
        let originalFontDesc = font.fontDescriptor
        let boldFontDesc = originalFontDesc.withSymbolicTraits(.traitBold)
        let boldFont = UIFont(descriptor: boldFontDesc!, size: size)
        return NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: boldFont])
    }
}
