//
//  MovieDetailsViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 9/22/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class MovieDetailsViewModel: NSObject, ViewModelElement {
    fileprivate enum CellType: Int {
        case avatar = 0
        case title = 1
        case description = 2
    }
    
    fileprivate var cellOrder: [CellType] = [.avatar, .title, .description]
    let movie: Movie
    let domain: String
    init(movie: Movie, submission: Submission) {
        self.movie = movie
        self.domain = submission.domain
    }
    
    func numberOfCells() -> Int {
        return cellOrder.count
    }
    
    func cell(index: Int) -> ASCellNode {
        let cellType = cellOrder[index]
        let titleColor = ThemeManager.textPrimary()
        
        switch cellType {
        case .avatar:
            let cell = CellNodeAvatarMeta()
            let logoSize: CGFloat = 35

            cell.textNodeTitle.attributedText = NSMutableAttributedString(
                string: self.domain.uppercased(),
                attributes: [
                    NSForegroundColorAttributeName: titleColor,
                    NSFontAttributeName: UIFont.systemFont(ofSize: 11, weight: UIFontWeightBold)
                ])
            
            cell.textNodeSubtitle.attributedText = NSMutableAttributedString(
                string: movie.author ?? "",
                attributes: [
                    NSForegroundColorAttributeName: ThemeManager.textSecondary(),
                    NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
                ])
            
            cell.imageNode.url = movie.logo
            cell.imageNode.style.preferredSize = CGSize(width: logoSize, height: logoSize)
            cell.inset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
            cell.textNodeTitle.isLayerBacked = true
            cell.textNodeSubtitle.isLayerBacked = true
            cell.imageNode.isLayerBacked = true
            return cell
            
        case .title:
            let cell = CellNodeText()
            
            cell.textNode.attributedText = NSMutableAttributedString(
                string: movie.title ?? "",
                attributes: [
                    NSForegroundColorAttributeName: titleColor,
                    NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
                ])
            
            cell.inset = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
            cell.textNode.isLayerBacked = true
            return cell
            
        case .description:
            let cell = CellNodeText()
            cell.textNode.attributedText = NSMutableAttributedString(
                string: movie.info ?? "",
                attributes: [
                    NSForegroundColorAttributeName: titleColor,
                    NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
                ])
            
            cell.inset = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
            cell.textNode.isLayerBacked = true
            return cell
        }
    }
}
