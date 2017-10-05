//
//  PhotoGridGroupViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 7/25/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import AsyncDisplayKit

protocol PhotoGridGroupViewModelDelegate {
    func didSelectMorePhotos()
}

class PhotoGridGroupViewModel: NSObject, ViewModelElement {
    
    let models: [MediaViewModel]
    var delegate: PhotoGridGroupViewModelDelegate? = nil
    
    enum CellType: Int {
        case grid = 1
        case header = 2
        case footer = 3
    }
    
    var cellOrder: [CellType] {
        var order = [CellType]()
        order.append(.header)
        order.append(.grid)
        order.append(.footer)
        return order
    }
    
    init(submissions: List<Submission>) {
        let filteredSubmissions = submissions.filter { (submission) -> Bool in
            return !submission.media.isEmpty
        }
        let media = filteredSubmissions.map({ (submission) -> MediaElement in
            var media = submission.media.first!.getMediaElement()!
            media.height = 1.0
            media.width = 1.0
            return media
        })
        self.models = media.map { (media) -> MediaViewModel in
            return MediaViewModel(media: media)
        }
    }
    
    func numberOfCells() -> Int {
        return cellOrder.count
    }
    
    func cell(index: Int) -> ASCellNode {
        let type = cellOrder[index]
        
        switch type {
            
        case .header:
            let text = NSMutableAttributedString(
                string: "Photos",
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold),
                    NSForegroundColorAttributeName: ThemeManager.textPrimary()
                ])
            let cell = CellNodeText(attributedText: text)
            cell.inset = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
            cell.separatorColor = ThemeManager.background()
            cell.hasSeparator = true
            cell.backgroundColor = ThemeManager.cellBackground()
            return cell
            
        case .footer:
            let cell = CellNodeMoreChevron()
            let font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
            let attributes = NSMutableAttributedString(
                string: "More Photos",
                attributes: [
                    NSFontAttributeName: font,
                    NSForegroundColorAttributeName: ThemeManager.textPrimary()
                ])
            cell.imageNode.image = #imageLiteral(resourceName: "right-chevron")
            cell.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(ThemeManager.cellAccessory())
            cell.textNode.attributedText = attributes
            cell.imageNode.contentMode = .scaleAspectFit
            cell.backgroundColor = ThemeManager.cellBackground()
            return cell
            
        case .grid:
            let cell = CellNodeMediaGrid(models: models)
            cell.separatorColor = ThemeManager.background()
            cell.backgroundColor = ThemeManager.cellBackground()
            cell.numberOfColumns = models.count < 3 ? models.count : 3
            cell.flowLayout.minimumInteritemSpacing = 5.0
            cell.flowLayout.minimumLineSpacing = 5.0
            cell.hasSeparator = true
            return cell
        }
    }
    
    func didSelect(index: Int) {
        guard let delegate = delegate else { return }
        if index == cellOrder.count - 1 {
            return delegate.didSelectMorePhotos()
        }
//        let subArr = Array(cellOrder[0...index])
//        let filterdArr = subArr.filter { $0 == .subreddit }
//        let model = models[filterdArr.count-1]
//        delegate.didSelectSubreddit(subreddit: model)
    }
}
