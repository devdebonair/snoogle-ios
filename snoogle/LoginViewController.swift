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
        let url = URL(string: "https://www.reddit.com/api/v1/authorize.compact?client_id=TrXPd_2qf8vU4w&response_type=code&state=_&redirect_uri=snoogle%3A%2F%2Freddit%2Fauth&duration=permanent&scope=creddits%20modcontributors%20modmail%20modconfig%20subscribe%20structuredstyles%20vote%20wikiedit%20mysubreddits%20submit%20modlog%20modposts%20modflair%20save%20modothers%20read%20privatemessages%20report%20identity%20livemanage%20account%20modtraffic%20wikiread%20edit%20modwiki%20modself%20history%20flair")
        guard let guardedUrl = url else { return }
        let controller = SFSafariViewController(url: guardedUrl)
        self.safariController = controller
        self.present(controller, animated: true, completion: nil)
    }
    
    func didReceiveAuthToken(notification: Notification) {
        guard let code = notification.object as? String else { return }
        print(code)
        self.safariController?.dismiss(animated: true, completion: nil)
        self.safariController = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
