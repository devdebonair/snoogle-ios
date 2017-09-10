//
//  Post.swift
//  snoogle
//
//  Created by Vincent Moore on 1/6/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

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
    
    func didTapLink() {
        guard let delegate = delegate else { return }
        delegate.didTapLink(post: self)
    }
    
    func didSelect(index: Int) {
        guard let delegate = delegate else { return }
        delegate.didSelectPost(post: self)
    }
    
    func didTapComments() {
        guard let delegate = delegate else { return }
        delegate.didTapComments(post: self)
    }
    
    func cell(index: Int) -> ASCellNode {
        let stickyColor = UIColor(colorLiteralRed: 38/255, green: 166/255, blue: 91/255, alpha: 1.0)
        let stickyFont = UIFont.systemFont(ofSize: 15, weight: UIFontWeightHeavy)
        
        let titleColor = UIColor(colorLiteralRed: 44/255, green: 45/255, blue: 48/255, alpha: 1.0)
//        let titleFont = UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)
        let titleFont = UIFont(name: "Charter-Bold", size: 16)!
        let titleLineSpacing: CGFloat = 2.0
        
        let metaFont = UIFont.systemFont(ofSize: 10)
        let metaColor = UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        let metaLineSpacing: CGFloat = 2.0
        
        let descriptionFont = UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)
//        let descriptionFont = UIFont(name: "Charter", size: 14)!
        let descriptionColor = UIColor(colorLiteralRed: 110/255, green: 110/255, blue: 110/255, alpha: 1.0)
        let descriptionLineSpacing: CGFloat = 2.0
        
        let linkTitleFont = UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)
        let linkTitleColor = UIColor(colorLiteralRed: 44/255, green: 45/255, blue: 48/255, alpha: 1.0)
        let linkTitleLineSpacing: CGFloat = 2.0
        
        let linkSubtitleFont = UIFont.systemFont(ofSize: 13)
        let linkSubtitleColor = UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        let linkSubtitleLineSpacing: CGFloat = 2.0
        
        let paragraphStyleMeta = NSMutableParagraphStyle()
        paragraphStyleMeta.lineSpacing = metaLineSpacing
        let meta = NSMutableAttributedString(
            string: self.meta,
            attributes: [
                NSFontAttributeName: metaFont,
                NSForegroundColorAttributeName: metaColor,
                NSParagraphStyleAttributeName: paragraphStyleMeta
            ])
        
        let paragraphStyleTitle = NSMutableParagraphStyle()
        paragraphStyleTitle.lineSpacing = titleLineSpacing
        
        let title = NSMutableAttributedString(
            string: self.title,
            attributes: [
                NSFontAttributeName: (isSticky ? stickyFont : titleFont),
                NSForegroundColorAttributeName: (isSticky ? stickyColor : titleColor),
                NSParagraphStyleAttributeName: paragraphStyleTitle
            ])
        
        let paragraphStyleDescription = NSMutableParagraphStyle()
        paragraphStyleDescription.lineSpacing = descriptionLineSpacing
        
        let description = NSMutableAttributedString(
            string: self.info,
            attributes: [
                NSFontAttributeName: descriptionFont,
                NSForegroundColorAttributeName: descriptionColor,
                NSParagraphStyleAttributeName: paragraphStyleDescription
            ])
        
        let post = CellNodePost(
            meta: meta,
            title: title,
            subtitle: description,
            media: self.media,
            vote: vote,
            saved: saved,
            numberOfComments: numberOfComments)
        
        self.cell = post
        
        post.textMeta.attributedText = meta
        post.textTitle.attributedText = title
        post.media = self.media
        post.textSubtitle.attributedText = description
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
                        NSForegroundColorAttributeName: titleColor,
                        NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
                    ])
                
                posterNode.textNodeDomain.attributedText = NSMutableAttributedString(
                    string: self.domain.uppercased(),
                    attributes: [
                        NSForegroundColorAttributeName: titleColor,
                        NSFontAttributeName: UIFont.systemFont(ofSize: 11, weight: UIFontWeightBold)
                    ])
                
                posterNode.textNodeAuthor.attributedText = NSMutableAttributedString(
                    string: movie.author ?? "",
                    attributes: [
                        NSForegroundColorAttributeName: UIColor(colorLiteralRed: 100/255, green: 105/255, blue: 130/255, alpha: 1.0),
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
                let color: Float = 220/255
                posterNode.backgroundNode.borderColor = UIColor(colorLiteralRed: color, green: color, blue: color, alpha: 1.0).cgColor
                
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
            })
            linkView.preview = self.media.first
            linkView.title = linkTitle
            linkView.subtitle = linkSubtitle
            let linkInset = UIEdgeInsets(top: 0, left: post.INSET_PADDING, bottom: post.INSET_PADDING, right: post.INSET_PADDING)
            let linkWithInset = ASInsetLayoutSpec(insets: linkInset, child: linkView)
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
    
    func didTapPoster(poster: CellNodeMoviePoster) {
        guard let delegate = delegate, let movie = self.media.first as? Movie else { return }
        self.delegate?.didTapPoster(poster: poster, movie: movie, post: self)
    }
    
    func didTapMedia(media: CellNodeMedia) {
        self.delegate?.didTapMedia(media: media)
    }
}
