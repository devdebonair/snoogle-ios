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

class ArticleViewController: ASViewController<ASCollectionNode>, ASCollectionDelegate, ASCollectionDataSource {
    
    let article: Article
    let listingId: String?
    
    let flowLayout = UICollectionViewFlowLayout()
    
    var comments = [Comment]()
    
    init(article: Article, listingId: String? = nil) {
        self.article = article
        self.listingId = listingId
        
        let collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        
        super.init(node: collectionNode)
        
        node.delegate = self
        node.dataSource = self
        node.registerSupplementaryNode(ofKind: UICollectionElementKindSectionFooter)
        
        flowLayout.footerReferenceSize = CGSize(width: node.bounds.width, height: 57)
        flowLayout.sectionFootersPinToVisibleBounds = true
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
    }
    
    override func viewDidLoad() {
        node.backgroundColor = UIColor(colorLiteralRed: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        if let listingId = listingId {
            Listing.getComments(id: listingId) { (comments: [Comment]) in
                self.comments = comments
                var paths = [IndexPath]()
                for index in 0..<comments.count {
                    let index = IndexPath(item: index, section: 1)
                    paths.append(index)
                }
                self.node.insertItems(at: paths)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let article = self.article
        var comment: Comment? = nil
        if indexPath.section == 1 {
            comment = comments[indexPath.row]
        }
        return { _ -> ASCellNode in
            
            if let comment = comment {
                var fontSizeMeta: CGFloat = 12
                var fontSizeBody: CGFloat = 14
                
                if comment.level != 0 {
                    fontSizeMeta = 10
                    fontSizeBody = 12
                }
                
                let meta = NSMutableAttributedString(
                    string: "\(comment.author) • \(comment.score) points",
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: fontSizeMeta),
                        NSForegroundColorAttributeName: UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
                    ])
                
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineSpacing = 4.0
                
                let body = NSMutableAttributedString(
                    string: comment.body,
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: fontSizeBody),
                        NSForegroundColorAttributeName: UIColor.black,
                        NSParagraphStyleAttributeName: paragraph
                    ])
                
                let leftMargin: CGFloat = 20 + CGFloat(comment.level * 20)
                var inset = UIEdgeInsets(top: 20, left: leftMargin, bottom: 20, right: 20)
                
                if comment.level != 0 {
                    inset.top = 5
                    inset.bottom = 5
                }
                
                let cell = CellNodeComment(meta: meta, body: body, inset: inset)
                cell.backgroundColor = .white
                cell.selectionStyle = .none
                return cell
            }
            
            let cell = article.cellAtRow(indexPath: indexPath)
            cell.backgroundColor = .white
            return cell
        }
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 2
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return comments.count
        }
        return article.numberOfCells()
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let width: CGFloat = node.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let max = CGSize(width: width, height: CGFloat(FLT_MAX))
        let min = CGSize(width: width, height: 0.0)
        return ASSizeRange(min: min, max: max)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        switch kind {
        case UICollectionElementKindSectionHeader:
            return ASCellNode()
        case UICollectionElementKindSectionFooter:
            let cell = CellNodeArticleButtonBar(numberOfComments: 55)
            cell.backgroundColor = .white
            return cell
        default:
            return ASCellNode()
        }
    }
}
