//
//  Service.swift
//  snoogle
//
//  Created by Vincent Moore on 3/27/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation

class Service {
    enum TransferProtocol: String {
        case http = "http"
        case https = "https"
    }
    var transfer: TransferProtocol = .http
//    var host = "45.55.221.50"
    var host = "192.168.1.249:3000"
    var version = "v1"
    var base: URL {
        return URL(string: "\(transfer.rawValue)://\(host)/\(version)/")!
    }
}
