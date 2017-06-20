//
//  MarkdownBlockElement.swift
//  snoogle
//
//  Created by Vincent Moore on 6/19/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

protocol MarkdownBlockElement: MarkdownStyleElement {
    var meta: [MarkdownInlineElement] { get }
    var text: String { get }
}
