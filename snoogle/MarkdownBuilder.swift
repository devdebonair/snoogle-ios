//
//  MarkdownBuilder.swift
//  snoogle
//
//  Created by Vincent Moore on 6/19/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

struct MarkdownBuilder {
    var customAttributes: [String:Any] = [:]
    
    func parseComponent(component: ArticleComponent, font: UIFont) -> NSMutableAttributedString? {
        guard let typeRaw = component.type, let type = MarkdownBlockType(rawValue: typeRaw) else { return nil }
        let retval = NSMutableAttributedString(string: component.text, attributes: customAttributes)
        retval.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, component.text.count))
        switch type {
        case .heading:
            let block = MarkdownHeader(meta: [], text: component.text, font: font, depth: component.depth).build()
            block.enumerateAttributes(in: NSMakeRange(0, component.text.count), options: [], using: { (attributes, range, pointer) in
                retval.addAttributes(attributes, range: range)
            })
            return retval
        case .blockquote:
            let block = MarkdownBlockQuote(meta: [], text: component.text, font: font).build()
            block.enumerateAttributes(in: NSMakeRange(0, component.text.count), options: [], using: { (attributes, range, pointer) in
                retval.addAttributes(attributes, range: range)
            })
            return retval
        case .paragraph:
            var meta = [MarkdownInlineElement]()
            for item in component.meta {
                if let element = parseMeta(meta: item, font: font) {
                    meta.append(element)
                }
            }
            let paragraph = MarkdownParagraph(meta: meta, text: component.text, font: font)
            let paragraphAttributes = paragraph.build()
            paragraphAttributes.enumerateAttributes(in: NSMakeRange(0, component.text.count), options: [], using: { (attributes, range, pointer) in
                retval.addAttributes(attributes, range: range)
            })
            return retval
        case .image:
            return nil
        case .code:
            let block = MarkdownCode(meta: [], text: component.text, font: font, lang: component.lang).build()
            block.enumerateAttributes(in: NSMakeRange(0, component.text.count), options: [], using: { (attributes, range, pointer) in
                retval.addAttributes(attributes, range: range)
            })
            return retval
        }
    }
    
    func parseMeta(meta: ArticleMeta, font: UIFont) -> MarkdownInlineElement? {
        guard let typeRaw = meta.type, let type = MarkdownInlineType(rawValue: typeRaw) else { return nil }
        let range = NSRange(location: meta.rangeStart, length: meta.rangeEnd - meta.rangeStart)
        switch type {
        case .strong:
            return MarkdownStrong(range: range, font: font)
        case .delete:
            return MarkdownDelete(range: range, font: font)
        case .emphasis:
            return MarkdownEmphasis(range: range, font: font)
        case .inlineCode:
            return MarkdownInlineCode(range: range, font: font)
        case .link:
            return MarkdownLink(range: range, url: meta.url, font: font)
        }
    }
}
