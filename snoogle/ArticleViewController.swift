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
    
    private enum SectionType: Int {
        case article = 0
        case comments = 1
    }
    
    let article: ArticleViewModel
    let listingId: String?
    let numberOfComments: Int
    
    let flowLayout = UICollectionViewFlowLayout()
    
    var comments = [Comment]()
    var commentViewModels = [CommentViewModel]()
    
    init(article: ArticleViewModel, listingId: String? = nil, numberOfComments: Int = 0) {
        self.article = article
        self.listingId = listingId
        self.numberOfComments = numberOfComments
        
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
                self.commentViewModels = []
                
                var paths = [IndexPath]()
                for index in 0..<comments.count {
                    let indexPath = IndexPath(item: index, section: 1)
                    paths.append(indexPath)
                    
                    let comment = comments[index]
                    let viewModel = CommentViewModel(
                        meta: "\(comment.author) • \(comment.score) points",
                        body: comment.body,
                        level: comment.level)
                    self.commentViewModels.append(viewModel)
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
        var commentViewModel: CommentViewModel? = nil
        
        if indexPath.section == SectionType.comments.rawValue {
            commentViewModel = commentViewModels[indexPath.row]
        }
        return { _ -> ASCellNode in
            
            if let commentViewModel = commentViewModel {
                return commentViewModel.cellAtRow(indexPath: indexPath)
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
            return commentViewModels.count
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
            let leftButtonText = "\(numberOfComments) Comments"
            let cell = CellNodeArticleButtonBar(leftButtonText: leftButtonText)
            cell.backgroundColor = .white
            return cell
        default:
            return ASCellNode()
        }
    }
}
