//
//  ArticleViewController.swift
//  snoogle
//
//  Created by Vincent Moore on 1/3/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class ArticleViewController: ASViewController<ASTableNode>, ASTableDelegate, ASTableDataSource {
    
    let meta: String
    let articleTitle: String
    let media: MediaElement?
    let content: [String]
    
    init(meta: String, title: String, media: MediaElement? = nil, content: [String]) {
        self.meta = meta
        self.articleTitle = title
        self.media = media
        self.content = content
        
        super.init(node: ASTableNode(style: .plain))
        
        node.delegate = self
        node.dataSource = self
    }
    
    override func viewDidLoad() {
        node.view.separatorStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        let meta = self.meta
        let title = self.articleTitle
        let media = self.media
        let content = self.content
        
        var index = indexPath.row
        
        if index > 1 && media == nil {
            index = index - 2
        }
        
        if index > 2 && media != nil {
            index = index - 3
        }
        
        return { _ -> ASCellNode in
            
            let cellNode: ASCellNode
            
            if indexPath.row == 0 {
                
                let meta = NSMutableAttributedString(
                    string: meta,
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                        NSForegroundColorAttributeName: UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
                    ])
                let inset = UIEdgeInsets(top: 20, left: 20, bottom: 5, right: 20)
                cellNode = CellNodeText(attributedText: meta, inset: inset)
                
            } else if indexPath.row == 1 {
            
                let inset = UIEdgeInsets(top: 5, left: 20, bottom: 10, right: 20)
                
                let paragraphStyleTitle = NSMutableParagraphStyle()
                paragraphStyleTitle.lineSpacing = 4.0
                
                let title = NSMutableAttributedString(
                    string: title,
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 20),
                        NSForegroundColorAttributeName: UIColor.black,
                        NSParagraphStyleAttributeName: paragraphStyleTitle
                    ])
                
                cellNode = CellNodeText(attributedText: title, inset: inset)
                
            } else if let media = media, indexPath.row == 2 {
                
                let inset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
                cellNode = CellNodeMedia(media: media, inset: inset)
                
            } else {
                
                let inset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
                let paragraphStyleDescription = NSMutableParagraphStyle()
                paragraphStyleDescription.lineSpacing = 6.0
                
                let description = NSMutableAttributedString(
                    string: content[index],
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 16),
                        NSForegroundColorAttributeName: UIColor.black,
                        NSParagraphStyleAttributeName: paragraphStyleDescription
                    ])
                cellNode = CellNodeText(attributedText: description, inset: inset)
            }
            
            cellNode.selectionStyle = .none
            
            return cellNode
        }
    }
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if media == nil {
            return 2 + content.count
        }
        
        return 3 + content.count
    }
}
