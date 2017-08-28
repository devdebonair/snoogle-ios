//
//  LoginViewController.swift
//  snoogle
//
//  Created by Vincent Moore on 8/9/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import SafariServices
import KeychainSwift
import RealmSwift

class LoginViewController: ASViewController<ASDisplayNode> {
    let button = ASButtonNode()
    let notification = Notification.Name(rawValue: "RedditAuthToken")
    var safariController: SFSafariViewController? = nil
    
    init() {
        super.init(node: ASDisplayNode())
    }
    
    override func viewDidLoad() {
        node.backgroundColor = .white
        
        self.node.addSubnode(button)
        
        button.cornerRadius = 5.0
        button.frame.size = CGSize(width: node.frame.width * 0.7, height: 60)
        button.backgroundColor = UIColor(colorLiteralRed: 0, green: 185/255, blue: 254/255, alpha: 1.0)
        button.view.center = self.node.view.center
        button.frame.origin.y = self.node.frame.height * 0.8
        
        let title = NSMutableAttributedString(string: "Login With Reddit", attributes: [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
            ])
        button.setAttributedTitle(title, for: [])
        
        button.addTarget(self, action: #selector(didTapButton), forControlEvents: .touchUpInside)
        
        self.navigationController?.isNavigationBarHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveAuthToken), name: notification, object: nil)
    }
    
    func didTapButton() {
        let url = URL(string: URL_AUTHENTICATION )
        guard let guardedUrl = url else { return }
        let controller = SFSafariViewController(url: guardedUrl)
        self.safariController = controller
        self.present(controller, animated: true, completion: nil)
    }
    
    func didReceiveAuthToken(notification: Notification) {
        guard let code = notification.object as? String else { return }
        self.safariController?.dismiss(animated: true, completion: nil)
        self.safariController = nil
        ServiceRedditAuth().fetchTokens(code: code) { [weak self] (name) in
            guard let weakSelf = self, let name = name else { return }
            let nameStripped = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            ServiceMe(user: nameStripped).fetch(completion: { (success) in
                if success {
                    do {
                        try AppUser.addAccount(name: name, isActive: true)
                        DispatchQueue.main.async {
                            weakSelf.dismiss(animated: true, completion: nil)
                        }
                    } catch {
                        print(error)
                    }
                } else {
                    print("an error occured")
                }
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
