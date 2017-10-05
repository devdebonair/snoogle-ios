//
//  CellNodeButtonState.swift
//  snoogle
//
//  Created by Vincent Moore on 9/27/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol CellNodeButtonStateDelegate {
    func didChangeState(state: CellNodeButtonState.State)
}

class CellNodeButtonState: CellNode {
    struct State: Equatable {
        var key: String = ""
        var color: UIColor = .lightGray
        var image: UIImage? = nil
        var text: NSMutableAttributedString? = nil
        
        static func ==(lhs: CellNodeButtonState.State, rhs: CellNodeButtonState.State) -> Bool {
            return lhs.key == rhs.key
        }
    }
    
    var states = [State]()
    fileprivate var button = ASButtonNode()
    fileprivate var selectedState: State? = nil
    var delegate: CellNodeButtonStateDelegate? = nil
    
    override init(didLoad: ((CellNode) -> Void)? = nil) {
        super.init(didLoad: didLoad)
        button.imageNode.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapButton), forControlEvents: .touchUpInside)
    }
    
    func selectState(state: State, animated: Bool = false) {
        guard self.states.contains(state) else { return }
        self.selectedState = state
        self.updateButton(state: state, animated: animated)
    }
    
    fileprivate func updateButton(state: State, animated: Bool = false) {
        if animated {
            button.animate(image: state.image, color: state.color, title: state.text)
        } else {
            button.setImage(nil, for: [])
            button.setImage(state.image, for: [])
            button.setAttributedTitle(state.text, for: [])
            button.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(state.color)
        }
    }
    
    override func willBuildLayout(constrainedSize: ASSizeRange) {
        if !self.states.isEmpty, self.selectedState == nil, let firstState = self.states.first {
            selectState(state: firstState)
        }
    }
    
    @objc fileprivate func didTapButton() {
        guard let currentState = self.selectedState, let index = self.states.index(of: currentState) else { return }
        if index == self.states.count - 1 {
            self.selectState(state: self.states[0], animated: true)
        } else if index < self.states.count {
            self.selectState(state: self.states[index+1], animated: true)
        }
        guard let delegate = self.delegate, let selectedState = self.selectedState else { return }
        delegate.didChangeState(state: selectedState)
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: button)
    }
}
