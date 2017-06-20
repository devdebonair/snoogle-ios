//
//  MarkdownInlineElement.swift
//  snoogle
//
//  Created by Vincent Moore on 6/19/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

protocol MarkdownInlineElement: MarkdownStyleElement {
    var range: NSRange { get }
    var type: MarkdownInlineType { get }
    func getAttributes() -> [String:Any]
}
