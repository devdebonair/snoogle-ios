//
//  ViewController.swift
//  snoogle
//
//  Created by Vincent Moore on 3/24/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    let service: ServiceSubreddit
    
    init(name: String) {
        service = ServiceSubreddit(name: name)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        service.listing(sort: .hot) { (success: Bool) in
            print("finished")
        }
    }
}
