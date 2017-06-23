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
    
    func getAttributes() -> [String : Any] {
        // TODO: Support custom colors for links
        guard let url = url else { return [:] }
        let color = UIColor(red: 0.0, green: 158/255, blue: 229/255, alpha: 1.0)
        return [
            NSLinkAttributeName: url,
            NSUnderlineColorAttributeName: color,
            NSForegroundColorAttributeName: color
        ]
    }
}
