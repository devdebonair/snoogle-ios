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

class PhotoGridGroupViewModel: NSObject, ViewModelElement {
    
    let models: [MediaViewModel]
    
    enum CellType: Int {
        case seperator = 0
        case grid = 1
        case header = 2
        case footer = 3
    }
    
    var cellOrder: [CellType] {
        var order = [CellType]()
        order.append(.header)
        order.append(.seperator)
        order.append(.grid)
        order.append(.seperator)
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
            
        case .seperator:
            let cell = CellNodeSeparator()
            let colorValue: Float = 240/255
            cell.separator.backgroundColor = UIColor(colorLiteralRed: colorValue, green: colorValue, blue: colorValue, alpha: 1.0)
            return cell
            
        case .header:
            let text = NSMutableAttributedString(
                string: "Photos",
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold),
                    NSForegroundColorAttributeName: UIColor.darkText
                ])
            let cell = CellNodeText(attributedText: text)
            cell.inset = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
            cell.backgroundColor = .white
            return cell
            
        case .footer:
            let cell = CellNodeMoreChevron()
            let font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
            let color = UIColor(colorLiteralRed: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
            let attributes = NSMutableAttributedString(
                string: "More Photos",
                attributes: [
                    NSFontAttributeName: font,
                    NSForegroundColorAttributeName: color
                ])
            cell.imageNode.image = #imageLiteral(resourceName: "right-chevron")
            cell.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(color)
            cell.textNode.attributedText = attributes
            cell.imageNode.contentMode = .scaleAspectFit
            cell.backgroundColor = .white
            return cell
            
        case .grid:
            let cell = CellNodeMediaGrid(models: models)
            cell.backgroundColor = .white
            cell.numberOfColumns = models.count < 3 ? models.count : 3
            cell.flowLayout.minimumInteritemSpacing = 5.0
            cell.flowLayout.minimumLineSpacing = 5.0
            return cell
        }
    }
}
