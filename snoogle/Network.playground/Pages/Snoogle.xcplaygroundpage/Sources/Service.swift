import Foundation

class Service {
    enum TransferProtocol: String {
        case http = "http"
        case https = "https"
    }
    var transfer: TransferProtocol = .http
    var host = "45.55.221.50"
    var version = "v1"
    var base: URL {
        return URL(string: "\(transfer.rawValue)://\(host)/\(version)/")!
    }
}
