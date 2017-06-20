//
//  MarkdownStrong.swift
//  snoogle
//
//  Created by Vincent Moore on 6/19/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

struct MarkdownStrong: MarkdownInlineElement {
    let range: NSRange
    let type: MarkdownInlineType = .strong
    var font: UIFont
    
    func getAttributes() -> [String:Any] {
        let originalFontDesc = font.fontDescriptor
        let boldFontDesc = originalFontDesc.withSymbolicTraits(.traitBold)
        let boldFont = UIFont(descriptor: boldFontDesc!, size: font.pointSize)
        return [NSFontAttributeName: boldFont]
    }
}
