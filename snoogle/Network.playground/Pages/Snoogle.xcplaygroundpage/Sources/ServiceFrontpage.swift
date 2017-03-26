import Foundation

class ServiceFrontPage: Service {
    func listing(sort: ListingSort = .hot, completion: ((Bool)->Void)? = nil) {
        requestListing(sort: sort) { (json: [String : Any]?) in
            // implement
        }
    }
}

extension ServiceFrontPage {
    func requestListing(sort: ListingSort = .hot, after: String? = nil, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "frontpage/\(sort.rawValue)", relativeTo: base)!
        var network = Network()
            .get()
            .url(url)
        
        if let after = after {
            network = network.query(key: "after", item: after)
        }
        
        network.parse(type: .json)
            .success() { (data, response) in
                return completion(data as? [String:Any])
            }
            .failure() { _ in
                return completion(nil)
            }
            .error() { _ in
                return completion(nil)
            }
            .sendHTTP()
    }
}
