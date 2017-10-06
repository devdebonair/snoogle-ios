//
//  MarkdownLink.swift
//  snoogle
//
//  Created by Vincent Moore on 6/19/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

struct MarkdownLink: MarkdownInlineElement {
    let range: NSRange
    let type: MarkdownInlineType = .link
    let url: URL?
    var font: UIFont
    var colorUnderline: UIColor = .blue
    var colorFont: UIColor = .blue
    
    func getAttributes() -> [String : Any] {
        // TODO: Support custom colors for links
        guard let url = url else { return [:] }
        return [
            NSLinkAttributeName: url,
            NSUnderlineColorAttributeName: colorUnderline,
            NSForegroundColorAttributeName: colorFont
        ]
    }
}
