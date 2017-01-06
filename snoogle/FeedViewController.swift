//
//  ViewController.swift
//  snoogle
//
//  Created by Vincent Moore on 12/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class FeedViewController: ASViewController<ASCollectionNode>, ASCollectionDelegate, ASCollectionDataSource {
    var model: [Listing] = []
    var after: String? = nil
    var shouldUpdate: Bool = false
    let flowLayout: UICollectionViewFlowLayout
    let subreddit: String = "rocketleague"
    let subSort: Listing.SortType = .hot

    init() {
        flowLayout = UICollectionViewFlowLayout()
        let collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        
        super.init(node: collectionNode)
        
        flowLayout.sectionInset = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        
        node.delegate = self
        node.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = UIColor(colorLiteralRed: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        Subreddit.fetchListing(name: subreddit, sort: subSort) { (listings: [Listing], isFinished: Bool, after: String?) in
            self.model.append(contentsOf: listings)
            self.shouldUpdate = !isFinished
            self.after = after
            self.node.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let nodeModel = model[indexPath.section]
        return { _ -> ASCellNode in
            let meta = NSMutableAttributedString(
                string: nodeModel.meta,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 12),
                    NSForegroundColorAttributeName: UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
                ])
            
            let paragraphStyleTitle = NSMutableParagraphStyle()
            paragraphStyleTitle.lineSpacing = 4.0
            
            let title = NSMutableAttributedString(
                string: nodeModel.title,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 17),
                    NSForegroundColorAttributeName: UIColor.black,
                    NSParagraphStyleAttributeName: paragraphStyleTitle
                ])
            
            let paragraphStyleDescription = NSMutableParagraphStyle()
            paragraphStyleDescription.lineSpacing = 4.0
            
            var descriptionShortened = nodeModel.selftext_condensed
            let maxCharacterLimit = 250
            if descriptionShortened.characters.count > maxCharacterLimit {
                descriptionShortened = descriptionShortened[0..<maxCharacterLimit]
                var arrayOfWords = descriptionShortened.components(separatedBy: .whitespacesAndNewlines)
                let _ = arrayOfWords.popLast()
                arrayOfWords.append(" ... (more)")
                descriptionShortened = arrayOfWords.joined(separator: " ")
            }
            let description = NSMutableAttributedString(
                string: descriptionShortened,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                    NSForegroundColorAttributeName: UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0),
                    NSParagraphStyleAttributeName: paragraphStyleDescription
                ])
            
            let buttonAttributes = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium),
                NSForegroundColorAttributeName: UIColor(colorLiteralRed: 50/255, green: 48/255, blue: 48/255, alpha: 1.0)
            ]
            
            let cell = CellNodeDetail(meta: meta, title: title, subtitle: description, buttonAttributes: buttonAttributes, media: nodeModel.media)
            
            return cell
        }
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return model.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let width: CGFloat = node.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let max = CGSize(width: width, height: CGFloat(FLT_MAX))
        let min = CGSize(width: width, height: 0.0)
        return ASSizeRange(min: min, max: max)
    }
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return shouldUpdate
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        Subreddit.fetchListing(name: subreddit, after: after, sort: subSort) { (listings: [Listing], isFinished: Bool, after: String?) in
            self.after = after
            self.shouldUpdate = !isFinished
            
            let prevModelCount = self.model.count
            self.model.append(contentsOf: listings)
            
            let set: IndexSet = IndexSet(integersIn: prevModelCount..<self.model.count)
            self.node.insertSections(set)
            context.completeBatchFetching(true)
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let listing = model[indexPath.section]
        let content = listing.selftext.components(separatedBy: .newlines)
        let article = Article(meta: listing.meta, title: listing.title, media: listing.media, content: content)
        let controller = ArticleViewController(article: article)
        present(controller, animated: true, completion: nil)
    }
    
}
