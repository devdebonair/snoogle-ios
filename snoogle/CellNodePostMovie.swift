//
//  CellNodePostMovie.swift
//  snoogle
//
//  Created by Vincent Moore on 8/27/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

protocol CellNodePostMovieDelegate {
    func didTapMovie()
}

class CellNodePostMovie: CellNode, CellNodePostActionBarDelegate, ASVideoNodeDelegate {
    
    let textMeta: ASTextNode
    let textTitle: ASTextNode
    let textSubtitle: ASTextNode
    let separator: ASDisplayNode
    let actionBar: CellNodePostActionBar
    let media: Movie
    
    var tagsView: NodeSlide? = nil
    var tagItems = [ViewModelElement]()
    
    var movieNode: CellNodeVideoPlayer
    
    var delegate: CellNodePostDelegate? = nil
    var delegateMovie: CellNodePostMovieDelegate? = nil
    
    let buttonVolume = ASButtonNode()
    
    init(meta: NSMutableAttributedString?, title: NSMutableAttributedString?, subtitle: NSMutableAttributedString?, media: Movie, vote: VoteType, saved: Bool, numberOfComments: Int = 0) {
        textMeta = ASTextNode()
        textTitle = ASTextNode()
        textSubtitle = ASTextNode()
        separator = ASDisplayNode()
        actionBar = CellNodePostActionBar(vote: vote, saved: saved, numberOfComments: numberOfComments)
        buttonVolume.imageNode.image = #imageLiteral(resourceName: "mute")
        buttonVolume.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.white)
        self.media = media
        
        movieNode = CellNodeVideoPlayer(media: media, didLoad: nil)
        movieNode.player.shouldAutoplay = true
        movieNode.player.muted = true
        movieNode.player.shouldAutorepeat = true
        
        super.init()
        
        movieNode.player.delegate = self
        
        textMeta.isLayerBacked = true
        textTitle.isLayerBacked = true
        textSubtitle.isLayerBacked = true
        separator.isLayerBacked = true
        
        actionBar.delegate = self
        
        automaticallyManagesSubnodes = true
        
        textMeta.attributedText = meta
        textTitle.attributedText = title
        textSubtitle.attributedText = subtitle
        
        let truncationText = subtitle
        truncationText?.mutableString.setString(" ... more")
        textSubtitle.truncationAttributedText = truncationText
        textSubtitle.maximumNumberOfLines = 5
        
        let separatorColor = UIColor(colorLiteralRed: 223/255, green: 223/255, blue: 227/255, alpha: 1.0)
        separator.backgroundColor = separatorColor
        
        self.buttonVolume.addTarget(self, action: #selector(didTapVolume), forControlEvents: .touchUpInside)
    }
    
    override func didLoad() {
        super.didLoad()
        self.shadowOffset = CGSize(width: 0, height: 1.0)
        self.backgroundColor = .white
        self.clipsToBounds = false
        self.shadowOpacity = 0.20
        self.shadowRadius = 1.0
        self.cornerRadius = 2.0
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
        self.buttonVolume.layer.shadowOpacity = 0.25
        self.buttonVolume.layer.shadowRadius = 4.0
    }
    
    func didTap(_ videoNode: ASVideoNode) {
        self.delegateMovie?.didTapMovie()
    }
    
    func didTapVolume() {
        self.movieNode.player.muted = !self.movieNode.player.muted
        if self.movieNode.player.muted {
            self.buttonVolume.imageNode.image = #imageLiteral(resourceName: "mute")
        } else {
            self.buttonVolume.imageNode.image = #imageLiteral(resourceName: "volume")
        }
    }
    
    override func didEnterDisplayState() {
        DispatchQueue.global(qos: .background).async {
            if let url = self.media.url {
                let asset = AVAsset(url: url)
                DispatchQueue.main.async {
                    self.movieNode.player.asset = asset
                }
            }
        }
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var contentLayoutElements = [ASLayoutElement]()
        contentLayoutElements.append(textMeta)
        contentLayoutElements.append(textTitle)
        
        if !tagItems.isEmpty {
            self.tagsView = NodeSlide(models: self.tagItems)
            if let layout = self.tagsView?.collectionNode.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.sectionInset.right = 10.0
            }
            self.tagsView?.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 20.0)
            if let tagsView = tagsView {
                contentLayoutElements.append(tagsView)
            }
        }
        
        if let subtitleText = textSubtitle.attributedText, !subtitleText.string.isEmpty {
            contentLayoutElements.append(textSubtitle)
        }
        
        let stackLayoutContent = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10.0,
            justifyContent: .start,
            alignItems: .start,
            children: contentLayoutElements)
        
        separator.style.width = ASDimension(unit: .fraction, value: 1.0)
        separator.style.height = ASDimension(unit: .points, value: 1.0)
        
        let padding: CGFloat = 20.0
        
        let inset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        let buttonInset = UIEdgeInsets(top: 14, left: padding, bottom: 14, right: padding)
        
        let insetContentLayout = ASInsetLayoutSpec(insets: inset, child: stackLayoutContent)
        let insetButtonLayout = ASInsetLayoutSpec(insets: buttonInset, child: actionBar)
        
        var stackContainerElements = [ASLayoutElement]()
        stackContainerElements.append(insetContentLayout)
        
        buttonVolume.style.preferredSize = CGSize(width: 25, height: 25)
        buttonVolume.imageNode.style.preferredSize = buttonVolume.style.preferredSize
        movieNode.style.width = ASDimension(unit: .fraction, value: 1.0)
        movieNode.style.height = ASDimension(unit: .fraction, value: 1.0)
        let insetButton = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 15)
        let insetSpec = ASInsetLayoutSpec(insets: insetButton, child: buttonVolume)
        let relativeSpec = ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .end, sizingOption: .minimumSize, child: insetSpec)
        let backgroundSpec = ASBackgroundLayoutSpec(child: relativeSpec, background: movieNode)
        let movieRatioSpec = ASRatioLayoutSpec(ratio: 720/1280, child: backgroundSpec)
        stackContainerElements.append(movieRatioSpec)
        
        if let subtitleText = textSubtitle.attributedText, !subtitleText.string.isEmpty {
            if let contentChildren = stackLayoutContent.children, contentChildren.count > 2 {
                let _ = stackLayoutContent.children?.popLast()
                let subtitleInset = UIEdgeInsets(top: 20, left: padding, bottom: 20, right: padding)
                let subtitleInsetLayout = ASInsetLayoutSpec(insets: subtitleInset, child: textSubtitle)
                stackContainerElements.append(subtitleInsetLayout)
            }
        }
        
        stackContainerElements.append(separator)
        stackContainerElements.append(insetButtonLayout)
        
        let stackContainer = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .start,
            alignItems: .start,
            children: stackContainerElements)
        
        return stackContainer
    }
    
    func didSave() {
        guard let delegate = delegate else { return }
        delegate.didSave()
    }
    
    func didUnsave() {
        guard let delegate = delegate else { return }
        delegate.didUnsave()
    }
    
    func didUnvote() {
        guard let delegate = delegate else { return }
        delegate.didUnvote()
    }
    
    func didUpvote() {
        guard let delegate = delegate else { return }
        delegate.didUpvote()
    }
    
    func didDownvote() {
        guard let delegate = delegate else { return }
        delegate.didDownvote()
    }
    
    func didTapComments() {
        guard let delegate = delegate else { return }
        delegate.didTapComments()
    }
    
    func videoNode(_ videoNode: ASVideoNode, didStallAtTimeInterval timeInterval: TimeInterval) {
        print("loading...")
    }
    
    func videoNodeDidStartInitialLoading(_ videoNode: ASVideoNode) {
        print("loading...")
    }
    
    func videoNodeDidRecover(fromStall videoNode: ASVideoNode) {
        print("resuming...")
    }
}
