//
//  CellNodeVideoPlayer.swift
//  snoogle
//
//  Created by Vincent Moore on 8/24/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import UIKit
import Foundation
import AsyncDisplayKit
import ChameleonFramework

class CellNodeVideoPlayer: CellNode, ASVideoNodeDelegate {
    let player = ASVideoNode()
    let size: CGSize
    let slider: Slider
    let textCurrentTime = ASTextNode()
    let textLeftoverTime = ASTextNode()
    let nodeSlider: ASDisplayNode
    let buttonPlayState = ASButtonNode()
    let buttonResize = ASButtonNode()
    let nodeOverlay = ASDisplayNode()
    let imageThumbNode = ASImageNode()
    
    var assetURL: URL? {
        didSet {
            DispatchQueue.global(qos: .background).async {
                if let url = self.assetURL {
                    let asset = AVAsset(url: url)
                    DispatchQueue.main.async {
                        self.player.asset = asset
                    }
                }
            }
        }
    }
    
    var isPlaying: Bool {
        return self.player.isPlaying()
    }
    
    var isControlsHidden: Bool = true {
        didSet {
            if self.isControlsHidden {
                self.hideControls()
            } else {
                self.showControls()
            }
        }
    }
    var isSliderBinded: Bool = true
    
    init(size: CGSize, didLoad: ((CellNode)->Void)? = nil) {
        self.size = size
        let slider = Slider()
        self.slider = slider
        self.nodeSlider = ASDisplayNode(viewBlock: { () -> UIView in
            return slider
        })
        super.init(didLoad: didLoad)
        if let image = #imageLiteral(resourceName: "circle").scaleToSize(newSize: CGSize(width: 20, height: 20)) {
            slider.setThumbImage(image, for: [])
        }
        self.slider.minimumValue = 0
        self.slider.maximumValue = 1
        self.slider.value = 0
        self.slider.addTarget(self, action: #selector(sliderDidChange(sender:)), for: .valueChanged)
        self.slider.addTarget(self, action: #selector(sliderDidStart(sender:)), for: .touchDown)
        self.slider.addTarget(self, action: #selector(sliderDidEnd(sender:)), for: UIControlEvents.touchUpInside)
        self.slider.addTarget(self, action: #selector(sliderDidEnd(sender:)), for: UIControlEvents.touchUpOutside)
        self.slider.minimumTrackTintColor = .white
        self.slider.isContinuous = true
        
        self.buttonPlayState.setImage(#imageLiteral(resourceName: "pause"), for: [])
        self.buttonPlayState.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.white)
        self.buttonPlayState.imageNode.contentMode = .scaleAspectFit
        self.buttonPlayState.style.preferredSize = CGSize(width: 30, height: 30)
        self.buttonPlayState.addTarget(self, action: #selector(didTapPlayButton), forControlEvents: .touchUpInside)
        
        self.buttonResize.setImage(#imageLiteral(resourceName: "resize"), for: [])
        self.buttonResize.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.white)
        self.buttonResize.imageNode.contentMode = .scaleAspectFit
        self.buttonResize.style.preferredSize = CGSize(width: 15, height: 15)
        
        self.nodeOverlay.isUserInteractionEnabled = false
        
        self.textCurrentTime.alpha = 0.0
        self.textLeftoverTime.alpha = 0.0
        self.nodeSlider.alpha = 0.0
        self.buttonPlayState.alpha = 0.0
        self.buttonResize.alpha = 0.0
        self.nodeOverlay.alpha = 0.0
        self.imageThumbNode.alpha = 0.0
        
        textCurrentTime.attributedText = NSMutableAttributedString(string: "0:00", attributes: [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 10, weight: UIFontWeightRegular)
        ])
        
        textLeftoverTime.attributedText = NSMutableAttributedString(string: "0:00", attributes: [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 10, weight: UIFontWeightMedium)
        ])
        
        self.player.delegate = self
        
        self.imageThumbNode.borderColor = UIColor.white.cgColor
        self.imageThumbNode.borderWidth = 1.0
        self.imageThumbNode.backgroundColor = .black
        
        automaticallyManagesSubnodes = false
        
        addSubnode(player)
        addSubnode(nodeOverlay)
        addSubnode(nodeSlider)
        addSubnode(textCurrentTime)
        addSubnode(textLeftoverTime)
        addSubnode(buttonPlayState)
        addSubnode(buttonResize)
        addSubnode(imageThumbNode)
    }
    
    override func layout() {
        let sizeToFit = CGSize(width: self.frame.width * 0.3, height: self.frame.height * 0.3)
        self.imageThumbNode.frame.size = self.size.fit(in: sizeToFit)
        self.nodeOverlay.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: nodeOverlay.bounds, andColors: [UIColor.black.withAlphaComponent(0.6), .clear, .clear, .clear])
    }
    
    func hideControls() {
        UIView.animate(withDuration: 0.2, delay: 0.1, options: [.curveEaseOut], animations: {
            self.textCurrentTime.alpha = 0.0
            self.textLeftoverTime.alpha = 0.0
            self.nodeSlider.alpha = 0.0
            self.buttonPlayState.alpha = 0.0
            self.buttonResize.alpha = 0.0
            self.nodeOverlay.alpha = 0.0
        }, completion: nil)
    }
    
    func showControls() {
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [.curveEaseOut], animations: {
            self.textCurrentTime.alpha = 1.0
            self.textLeftoverTime.alpha = 1.0
            self.nodeSlider.alpha = 1.0
            self.buttonPlayState.alpha = 1.0
            self.buttonResize.alpha = 1.0
            self.nodeOverlay.alpha = 1.0
        }, completion: nil)
    }
    
    func sliderDidStart(sender: UISlider) {
        self.isSliderBinded = false
        UIView.animate(withDuration: 0.8) {
            self.imageThumbNode.alpha = 1.0
        }
    }
    
    func sliderDidChange(sender: Slider) {
        self.imageThumbNode.view.center = sender.attachmentPoint()
        let percentage = Double(sender.value)
        DispatchQueue.global(qos: .background).async {
            let image = self.player.generateThumbnail(percentage: percentage)
            DispatchQueue.main.async {
                self.imageThumbNode.image = image
            }
        }
    }
    
    func sliderDidEnd(sender: UISlider) {
        guard let currentItem = self.player.currentItem else { return }
        self.player.pause()
        let percentage = Double(sender.value)
        let time = CMTime(seconds: currentItem.duration.seconds * percentage, preferredTimescale: 1)
        currentItem.seek(to: time)
        self.player.play()
        self.isSliderBinded = true
        UIView.animate(withDuration: 0.8) {
            self.imageThumbNode.alpha = 0.0
        }
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var ratio = size.width / size.height
        if size.width <= 0 || size.height <= 0 { ratio = 720 / 1280 }
        
        nodeSlider.style.width = ASDimension(unit: .points, value: 200)
        nodeSlider.style.height = ASDimension(unit: .points, value: 20.0)
        
        textLeftoverTime.style.width = ASDimension(unit: .points, value: 30)
        textCurrentTime.style.width = ASDimension(unit: .points, value: 30)
        
        let trackStack = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .center, children: [buttonPlayState, textCurrentTime, nodeSlider, textLeftoverTime, buttonResize])
        trackStack.style.width = ASDimension(unit: .fraction, value: 1.0)
        
        let trackInset = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)
        let relativeStack = ASRelativeLayoutSpec(horizontalPosition: .center, verticalPosition: .end, sizingOption: .minimumSize, child: trackStack)
        let insetLayout = ASInsetLayoutSpec(insets: trackInset, child: relativeStack)
        
        let backgroundStack = ASBackgroundLayoutSpec(child: insetLayout, background: nodeOverlay)
        let backgroundOverlayStack = ASBackgroundLayoutSpec(child: backgroundStack, background: player)
        
        return ASRatioLayoutSpec(ratio: ratio, child: backgroundOverlayStack)
    }
    
    func videoNode(_ videoNode: ASVideoNode, didPlayToTimeInterval timeInterval: TimeInterval) {
        guard let currentItem = videoNode.currentItem else { return }
        let totalSeconds = Float(currentItem.duration.seconds)
        let elapsedSeconds = Float(timeInterval)
        if isSliderBinded {
            let percentage = elapsedSeconds / totalSeconds
            self.slider.value = percentage
            self.imageThumbNode.view.center = self.slider.attachmentPoint()
        }
        
        let totalSecondsPassed = Int(elapsedSeconds.truncatingRemainder(dividingBy: 60))
        let totalMinutesPassed = Int(elapsedSeconds / 60)
        let durationAsString = "\(totalMinutesPassed):\(String(format: "%02d", totalSecondsPassed))"
        self.textCurrentTime.attributedText = NSMutableAttributedString(
            string: durationAsString,
            attributes: [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont.systemFont(ofSize: 10, weight: UIFontWeightMedium)
        ])
        
        let totalSecondsLeft = Int((totalSeconds - elapsedSeconds).truncatingRemainder(dividingBy: 60))
        let totalMinutesLeft = Int((totalSeconds - elapsedSeconds) / 60)
        let durationLeftAsString = "\(totalMinutesLeft):\(String(format: "%02d", totalSecondsLeft))"
        self.textLeftoverTime.attributedText = NSMutableAttributedString(
            string: durationLeftAsString,
            attributes: [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont.systemFont(ofSize: 10, weight: UIFontWeightMedium)
            ])
    }
    
    func didTapPlayButton() {
        if isPlaying {
            self.buttonPlayState.setImage(#imageLiteral(resourceName: "play"), for: [])
            self.player.pause()
        } else {
            self.buttonPlayState.setImage(#imageLiteral(resourceName: "pause"), for: [])
            self.player.play()
        }
    }
    
    func videoNode(_ videoNode: ASVideoNode, willChange state: ASVideoNodePlayerState, to toState: ASVideoNodePlayerState) {
        if let currentItem = videoNode.currentItem, state == .readyToPlay {
            let totalMinutes = Int(currentItem.duration.seconds / 60)
            let totalSeconds = Int(currentItem.duration.seconds.truncatingRemainder(dividingBy: 60))
            let durationAsString = "\(totalMinutes):\(String(format: "%02d", totalSeconds))"
            self.textLeftoverTime.attributedText = NSMutableAttributedString(
                string: durationAsString,
                attributes: [
                    NSForegroundColorAttributeName: UIColor.white,
                    NSFontAttributeName: UIFont.systemFont(ofSize: 10, weight: UIFontWeightMedium)
                ])
        }
    }
    
    func didTap(_ videoNode: ASVideoNode) {
        self.isControlsHidden = !self.isControlsHidden
    }
}
