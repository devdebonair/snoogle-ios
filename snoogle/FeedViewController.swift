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
    let flowLayout: UICollectionViewFlowLayout
    
    init() {
        flowLayout = UICollectionViewFlowLayout()
        let collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        
        super.init(node: collectionNode)
        
        flowLayout.sectionInset = UIEdgeInsets(top: 7.5, left: 8.0, bottom: 7.5, right: 8.0)
        
        node.delegate = self
        node.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = UIColor(colorLiteralRed: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        
        Subreddit.fetchListing(name: "iosprogramming") { (listings: [Listing]) in
            self.model.append(contentsOf: listings)
            self.node.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let nodeModel = model[indexPath.section]
        return { _ -> ASCellNode in
            let meta = NSAttributedString(
                string: "\(nodeModel.author) • \(nodeModel.date_created.timeAgo(numericDates: true))",
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 12),
                    NSForegroundColorAttributeName: UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
                ])
            
            let title = NSAttributedString(
                string: nodeModel.title,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 18),
                    NSForegroundColorAttributeName: UIColor(colorLiteralRed: 50/255, green: 48/255, blue: 48/255, alpha: 1.0)
                ])
            
            let description = NSAttributedString(
                string: nodeModel.selftext_condensed,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                    NSForegroundColorAttributeName: UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
                ])
            
            let buttonAttributes = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor(colorLiteralRed: 50/255, green: 48/255, blue: 48/255, alpha: 1.0)
            ]
            
            let cell = CellNodeDetail(meta: meta, title: title, subtitle: description, buttonAttributes: buttonAttributes)
            
            cell.shadowOffset = CGSize(width: 0, height: 1.0)
            cell.backgroundColor = .white
            cell.clipsToBounds = false
            cell.shadowOpacity = 0.20
            cell.shadowRadius = 1.0
            cell.cornerRadius = 2.0
            
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
}

