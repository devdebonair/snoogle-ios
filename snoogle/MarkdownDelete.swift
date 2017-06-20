//
//  MarkdownDelete.swift
//  snoogle
//
//  Created by Vincent Moore on 6/19/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

struct MarkdownDelete: MarkdownInlineElement {
    let range: NSRange
    let type: MarkdownInlineType = .delete
    var font: UIFont
    
    func getAttributes() -> [String : Any] {
        return [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
    }
}
