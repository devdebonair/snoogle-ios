//
//  CellNodeUserKarma.swift
//  snoogle
//
//  Created by Vincent Moore on 5/31/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeUserKarma: ASCellNode {
    let imageBirthday = ASImageNode()
    let imageKarma = ASImageNode()
    let textAge = ASTextNode()
    let textAgeStat = ASTextNode()
    let textKarma = ASTextNode()
    let textKarmaStat = ASTextNode()
    
    init(age: Date, karma: Int) {
        super.init()
        imageKarma.image = #imageLiteral(resourceName: "karma")
        imageBirthday.image = #imageLiteral(resourceName: "birthday")
        
        textAgeStat.attributedText = NSAttributedString(string: age.timeAgo(numericDates: true, shortened: false), attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        ])
        textKarmaStat.attributedText = NSAttributedString(string: "\(karma) Karma", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        ])
        
        textAge.attributedText = NSAttributedString(string: "Reddit Age", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular),
            NSForegroundColorAttributeName: UIColor.lightGray
        ])
        textKarma.attributedText = NSAttributedString(string: "Reputation", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular),
            NSForegroundColorAttributeName: UIColor.lightGray
        ])
        
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackKarmaText = ASStackLayoutSpec(direction: .vertical, spacing: 2.0, justifyContent: .start, alignItems: .start, children: [textKarmaStat,textKarma])
        let stackKarma = ASStackLayoutSpec(direction: .horizontal, spacing: 15.0, justifyContent: .start, alignItems: .center, children: [imageKarma, stackKarmaText])
        let stackBirthdayText = ASStackLayoutSpec(direction: .vertical, spacing: 1.0, justifyContent: .start, alignItems: .start, children: [textAgeStat,textAge])
        let stackBirthday = ASStackLayoutSpec(direction: .horizontal, spacing: 15.0, justifyContent: .start, alignItems: .center, children: [imageBirthday, stackBirthdayText])
        let stackContainer = ASStackLayoutSpec(direction: .horizontal, spacing: 80.0, justifyContent: .center, alignItems: .stretch, children: [stackKarma, stackBirthday])
        let insetValue: CGFloat = 10.0
        let inset = UIEdgeInsets(top: insetValue, left: insetValue, bottom: insetValue, right: insetValue)
        let insetLayout = ASInsetLayoutSpec(insets: inset, child: stackContainer)
        return insetLayout
    }
}
