//
//  SearchPhotoCollectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 7/27/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SearchPhotoCollectionController: CollectionController, MosaicCollectionViewLayoutDelegate {
    
    let inspector = MosaicCollectionViewLayoutInspector()
    
    init() {
        super.init(collectionLayout: MosaicCollectionViewLayout())
        collectionNode.layoutInspector = inspector
        if let flowLayout = flowLayout as? MosaicCollectionViewLayout {
            flowLayout.delegate = self
            flowLayout.numberOfColumns = 2
            flowLayout.headerHeight = 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = [.top]
        extendedLayoutIncludesOpaqueBars = true
        let bottomInset: CGFloat = (self.navigationController?.toolbar.frame.height ?? 0) + self.bottomLayoutGuide.length + 200
        collectionNode.view.contentInset = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: bottomInset, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: MosaicCollectionViewLayout, originalItemSizeAtIndexPath: IndexPath) -> CGSize {
        guard let guardedModels = models as? [MultipleMediaViewModel] else { return .zero }
        let model = guardedModels[originalItemSizeAtIndexPath.section].models[originalItemSizeAtIndexPath.row]
        return CGSize(width: model.media.width, height: model.media.height)
    }
}
