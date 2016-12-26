//
//  ViewController.swift
//  snoogle
//
//  Created by Vincent Moore on 12/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class FeedViewController: ASViewController<ASTableNode>, ASTableDelegate, ASTableDataSource {

    init() {
        let tableNode = ASTableNode()
        super.init(node: tableNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let inset: CGFloat = 8.0
        node.view.contentInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { _ -> ASCellNode in
            return ASCellNode()
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 20
    }
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return true
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        return
    }

}

