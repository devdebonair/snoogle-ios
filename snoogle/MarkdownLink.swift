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
        guard let url = url else { return [:] }
        return [NSLinkAttributeName: url]
    }
}
