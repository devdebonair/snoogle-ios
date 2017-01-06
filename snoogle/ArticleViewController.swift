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
    let flowLayout = UICollectionViewFlowLayout()
    
    init(article: Article) {
        self.article = article
        
        let collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: collectionNode)
        
        node.delegate = self
        node.dataSource = self
        node.registerSupplementaryNode(ofKind: UICollectionElementKindSectionFooter)
        
        flowLayout.footerReferenceSize = CGSize(width: node.bounds.width, height: 55)
        flowLayout.sectionFootersPinToVisibleBounds = true
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
    }
    
    override func viewDidLoad() {
        node.backgroundColor = UIColor(colorLiteralRed: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let article = self.article
        return { _ -> ASCellNode in
            let cell = article.cellAtRow(indexPath: indexPath)
            cell.backgroundColor = .white
            return cell
        }
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
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
