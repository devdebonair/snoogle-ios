//
//  Post.swift
//  snoogle
//
//  Created by Vincent Moore on 1/6/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import ChameleonFramework

protocol PostViewModelDelegate {
    func didSelectPost(post: PostViewModel)
    func didTapLink(post: PostViewModel)
    func didUpvote(post: PostViewModel)
    func didDownvote(post: PostViewModel)
    func didSave(post: PostViewModel)
    func didUnsave(post: PostViewModel)
    func didUnvote(post: PostViewModel)
    func didTapComments(post: PostViewModel)
    func didTapMedia(media: CellNodeMedia)
    func didTapPoster(poster: CellNodeMoviePoster, movie: Movie, post: PostViewModel)
}

class PostViewModel: NSObject, ViewModelElement, CellNodeMediaDelegate, CellNodeMovieMetaInfoDelegate {
    let meta: String
    let title: String
    let info: String
    let media: [MediaElement]
    let numberOfComments: Int
    let id: String
    let isSticky: Bool
    let vote: VoteType
    let saved: Bool
    var hint: PostHintType?
    let domain: String
    
    var tags = [TagViewModel]()
    
    var delegate: PostViewModelDelegate? = nil
    var cell: CellNode? = nil
    var cellLink: CellNodeLink? = nil
    
    init(id: String, meta: String = "", title: String = "", info: String = "", media: [MediaElement] = [], numberOfComments: Int = 0, inSub: Bool = false, isSticky: Bool = false, vote: VoteType = .none, saved: Bool = false, hint: PostHintType? = nil, domain: String = "") {
        self.id = id
        self.meta = meta
        self.title = title
        self.info = info
        self.media = media
        self.numberOfComments = numberOfComments
        self.isSticky = isSticky
        self.vote = vote
        self.saved = saved
        self.hint = hint
        self.domain = domain
    }
    
    override func primaryKey() -> NSObjectProtocol {
        return NSString(string: id)
    }
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func didTapLink() {
        guard let delegate = delegate else { return }
        delegate.didTapLink(post: self)
    }
    
    func didSelect(index: Int) {
        guard let delegate = delegate else { return }
        delegate.didSelectPost(post: self)
    }
    
    func cell(index: Int) -> ASCellNode {
        let linkTitleFont = UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)
        let linkTitleColor = ThemeManager.textPrimary()
        let linkTitleLineSpacing: CGFloat = 2.0
        
        let linkSubtitleFont = UIFont.systemFont(ofSize: 13)
        let linkSubtitleColor = ThemeManager.textSecondary()
        let linkSubtitleLineSpacing: CGFloat = 2.0
        
        let post = CellNodePost(
            vote: vote,
            saved: saved)
        
        post.delegatePostAction = self
        
        setTheme(cell: post)
        
        self.cell = post

        post.media = self.media
        post.textSubtitle.maximumNumberOfLines = 5
        post.tagItems = tags
                
        guard let hint = hint else { return post }
        
        switch hint {
            
        case .movie:
            if let movie = self.media.first as? Movie {
                let photo = Photo(width: 1280, height: 720, url: nil, urlSmall: nil, urlMedium: nil, urlLarge: nil, urlHuge: movie.poster, info: movie.info)
                let posterNode = CellNodeMovieMetaInfo(photo: photo)
                posterNode.imageNodePlay.imageModificationBlock = ASImageNodeTintColorModificationBlock(.white)
                posterNode.imageNodeLogo.url = movie.logo
                let logoSize: CGFloat = 35
                posterNode.imageNodeLogo.style.preferredSize = CGSize(width: logoSize, height: logoSize)
                
                posterNode.textNodeTitle.attributedText = NSMutableAttributedString(
                    string: movie.title ?? "",
                    attributes: [
                        NSForegroundColorAttributeName: ThemeManager.textPrimary(),
                        NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
                    ])
                
                posterNode.textNodeDomain.attributedText = NSMutableAttributedString(
                    string: self.domain.uppercased(),
                    attributes: [
                        NSForegroundColorAttributeName: ThemeManager.textPrimary(),
                        NSFontAttributeName: UIFont.systemFont(ofSize: 11, weight: UIFontWeightBold)
                    ])
                
                posterNode.textNodeAuthor.attributedText = NSMutableAttributedString(
                    string: movie.author ?? "",
                    attributes: [
                        NSForegroundColorAttributeName: UIColor(red: 100/255, green: 105/255, blue: 130/255, alpha: 1.0),
                        NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
                    ])
                
                posterNode.delegate = self
                
                posterNode.inset = UIEdgeInsets(top: 0, left: 12, bottom: 10, right: 12)
                let movieMargin: CGFloat = 4
                posterNode.cellNodeMoviePoster.inset.left = -posterNode.INSET_FOR_STACK + -posterNode.inset.left + movieMargin
                posterNode.cellNodeMoviePoster.inset.right = -posterNode.INSET_FOR_STACK + -posterNode.inset.right + movieMargin
                posterNode.cellNodeMoviePoster.clipsToBounds = false
                posterNode.clipsToBounds = false
                posterNode.backgroundNode.borderWidth = 1.0
                let color: CGFloat = 220/255
                posterNode.backgroundNode.borderColor = UIColor(red: color, green: color, blue: color, alpha: 1.0).cgColor
                
                posterNode.backgroundNode.isLayerBacked = true
                posterNode.imageNodeLogo.isLayerBacked = true
                posterNode.textNodeAuthor.isLayerBacked = true
                posterNode.textNodeDomain.isLayerBacked = true
                posterNode.imageNodePlay.isLayerBacked = true
                posterNode.textNodeTitle.isLayerBacked = true
                
                post.add(attachment: posterNode)
            }
            
        case .link:
            let paragraphStyleLinkTitle = NSMutableParagraphStyle()
            paragraphStyleLinkTitle.lineSpacing = linkTitleLineSpacing
            
            let paragraphStyleLinkSubtitle = NSMutableParagraphStyle()
            paragraphStyleLinkSubtitle.lineSpacing = linkSubtitleLineSpacing
            
            let linkTitle = NSMutableAttributedString(
                string: self.title,
                attributes: [
                    NSFontAttributeName: linkTitleFont,
                    NSForegroundColorAttributeName: linkTitleColor,
                    NSParagraphStyleAttributeName: paragraphStyleLinkTitle
                ])
            
            let linkSubtitle = NSMutableAttributedString(
                string: domain,
                attributes: [
                    NSFontAttributeName: linkSubtitleFont,
                    NSForegroundColorAttributeName: linkSubtitleColor,
                    NSParagraphStyleAttributeName: paragraphStyleLinkSubtitle
                ])
            let linkView = CellNodeLink(didLoad: { (cell) in
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapLink))
                cell.view.addGestureRecognizer(tap)
                cell.borderColor = ThemeManager.cellBackground().darken(byPercentage: 0.2)!.cgColor
                cell.backgroundColor = ThemeManager.cellBackground().darken(byPercentage: 0.03)!
            })
            linkView.preview = self.media.first
            linkView.textTitle.attributedText = linkTitle
            linkView.textSubtitle.attributedText = linkSubtitle
            let linkInset = UIEdgeInsets(top: 0, left: post.INSET_PADDING, bottom: post.INSET_PADDING, right: post.INSET_PADDING)
            let linkWithInset = ASInsetLayoutSpec(insets: linkInset, child: linkView)
            
            linkView.textTitle.isLayerBacked = true
            linkView.textSubtitle.isLayerBacked = true
            linkView.media.isLayerBacked = true
            
            self.cellLink = linkView
            
            post.add(attachment: linkWithInset)
            
        default:
            if !media.isEmpty {
                if media.count > 1 {
                    let slider = CellNodeMediaAlbum(media: media)
                    let inset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
                    let insetLayout = ASInsetLayoutSpec(insets: inset, child: slider)
                    slider.flowLayout.sectionInset = UIEdgeInsets(top: 0, left: post.INSET_PADDING, bottom: 0, right: post.INSET_PADDING)
                    post.add(attachment: insetLayout)
                }
                if let media = self.media.first, self.media.count == 1 {
                    let mediaView = CellNodeMedia(media: media)
                    mediaView.delegate = self
                    post.add(attachment: mediaView)
                }
            }
        }
        
        return post
    }
    
    func setTheme(cell: CellNodePost) {
        cell.backgroundColor = ThemeManager.cellBackground()
        
        let metaFont = UIFont.systemFont(ofSize: 10)
        let metaColor = ThemeManager.textSecondary()
        let metaLineSpacing: CGFloat = 2.0
        let paragraphStyleMeta = NSMutableParagraphStyle()
        paragraphStyleMeta.lineSpacing = metaLineSpacing
        
        let titleColor: UIColor = ThemeManager.textPrimary()
        let titleFont = UIFont(name: "Charter-Bold", size: 16)!
        let titleLineSpacing: CGFloat = 2.0
        let paragraphStyleTitle = NSMutableParagraphStyle()
        paragraphStyleTitle.lineSpacing = titleLineSpacing
        
        let descriptionFont = UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)
        let descriptionColor = ThemeManager.textSecondary()
        let descriptionLineSpacing: CGFloat = 2.0
        let paragraphStyleDescription = NSMutableParagraphStyle()
        paragraphStyleDescription.lineSpacing = descriptionLineSpacing
        
        let meta = NSMutableAttributedString(
            string: self.meta,
            attributes: [
                NSFontAttributeName: metaFont,
                NSForegroundColorAttributeName: metaColor,
                NSParagraphStyleAttributeName: paragraphStyleMeta
            ])
        
        let title = NSMutableAttributedString(
            string: self.title,
            attributes: [
                NSFontAttributeName: titleFont,
                NSForegroundColorAttributeName: titleColor,
                NSParagraphStyleAttributeName: paragraphStyleTitle
            ])
        
        
        let description = NSMutableAttributedString(
            string: self.info,
            attributes: [
                NSFontAttributeName: descriptionFont,
                NSForegroundColorAttributeName: descriptionColor,
                NSParagraphStyleAttributeName: paragraphStyleDescription
            ])
        
        cell.textMeta.attributedText = meta
        cell.textTitle.attributedText = title
        cell.textSubtitle.attributedText = description
        cell.separator.backgroundColor = ThemeManager.background()
        
        for item in cell.attachments {
            if let item = item as? ASCellNode {
                item.backgroundColor = ThemeManager.cellBackground()
            }
        }
        
        if let linkCell = self.cellLink {
            let linkTitleFont = UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)
            let linkTitleColor = ThemeManager.textPrimary()
            let linkTitleLineSpacing: CGFloat = 2.0
            
            let linkSubtitleFont = UIFont.systemFont(ofSize: 13)
            let linkSubtitleColor = ThemeManager.textSecondary()
            let linkSubtitleLineSpacing: CGFloat = 2.0
            
            let paragraphStyleLinkTitle = NSMutableParagraphStyle()
            paragraphStyleLinkTitle.lineSpacing = linkTitleLineSpacing
            
            let paragraphStyleLinkSubtitle = NSMutableParagraphStyle()
            paragraphStyleLinkSubtitle.lineSpacing = linkSubtitleLineSpacing
            
            let linkTitle = NSMutableAttributedString(
                string: self.title,
                attributes: [
                    NSFontAttributeName: linkTitleFont,
                    NSForegroundColorAttributeName: linkTitleColor,
                    NSParagraphStyleAttributeName: paragraphStyleLinkTitle
                ])
            
            let linkSubtitle = NSMutableAttributedString(
                string: domain,
                attributes: [
                    NSFontAttributeName: linkSubtitleFont,
                    NSForegroundColorAttributeName: linkSubtitleColor,
                    NSParagraphStyleAttributeName: paragraphStyleLinkSubtitle
                ])
            
            linkCell.backgroundColor = ThemeManager.cellBackground().darken(byPercentage: 0.03)!
            linkCell.textTitle.attributedText = linkTitle
            linkCell.textSubtitle.attributedText = linkSubtitle
            linkCell.borderColor = ThemeManager.cellBackground().cgColor
        }
    }
    
    func didTapPoster(poster: CellNodeMoviePoster) {
        guard let delegate = delegate, let movie = self.media.first as? Movie else { return }
        delegate.didTapPoster(poster: poster, movie: movie, post: self)
    }
    
    func didTapMedia(media: CellNodeMedia) {
        self.delegate?.didTapMedia(media: media)
    }
}

extension PostViewModel: ThemableElement {
    func configureTheme() {
        guard let cell = cell as? CellNodePost else { return }
        UIView.animate(withDuration: 0.8, animations: {
            self.setTheme(cell: cell)
        })
    }
}

extension PostViewModel: CellNodePostActionDelegate {
    func didUpvote() {
        guard let delegate = delegate else { return }
        delegate.didUpvote(post: self)
    }
    
    func didDownvote() {
        guard let delegate = delegate else { return }
        delegate.didDownvote(post: self)
    }
    
    func didSave() {
        guard let delegate = delegate else { return }
        delegate.didSave(post: self)
    }
    
    func didUnsave() {
        guard let delegate = delegate else { return }
        delegate.didUnsave(post: self)
    }
    
    func didUnvote() {
        guard let delegate = delegate else { return }
        delegate.didUnvote(post: self)
    }
    
    func didComment() {
        guard let delegate = delegate else { return }
        delegate.didTapComments(post: self)
    }
}
