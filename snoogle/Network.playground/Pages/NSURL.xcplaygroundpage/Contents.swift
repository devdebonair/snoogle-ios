//: [Previous](@previous)

import Foundation
import PlaygroundSupport


let urlString = "https://api.chucknorris.io/jokes/random"
let url = URL(string: urlString)!

url.absoluteString
url.scheme
url.host
url.path
url.query
url.baseURL



let baseURL = URL(string: "https://snoogleapp.herokuapp.com")
let relativeURL = URL(string: "r/rocketleague/hot", relativeTo: baseURL)
relativeURL?.absoluteString
relativeURL?.scheme
relativeURL?.host
relativeURL?.path
relativeURL?.query
relativeURL?.baseURL



var components = URLComponents(url: relativeURL!, resolvingAgainstBaseURL: true)
components?.string
components?.url
components?.scheme
components?.host
components?.path
components?.query
components?.query = "format=json"
components?.query
let item = URLQueryItem(name: "nojsoncallback", value: "1")
components?.queryItems?.append(item)
components?.query
components?.url


let request = NSMutableURLRequest(url: components!.url!)
request.allowsCellularAccess = false
request.httpMethod = "GET"
request.allHTTPHeaderFields
request.setValue("application/x-www/form-urlencoded", forHTTPHeaderField: "Content-Type")
request.allHTTPHeaderFields
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
request.allHTTPHeaderFields


PlaygroundPage.current.needsIndefiniteExecution = true

let session = URLSession.shared
let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
    guard let response = response as? HTTPURLResponse, let data = data else { return }
//    defer { PlaygroundPage.current.finishExecution() }
    
    let headers = response.allHeaderFields
    response.statusCode
    
    let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
}
task.resume()



let newUrl = URL(string: "http://www.example.com")!
var newRequest = URLRequest(url: newUrl)
newRequest.httpMethod = "POST"
newRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

let newComponents = NSURLComponents()
newComponents.query = "param=value&otherparam=another value"
let body = newComponents.percentEncodedQuery!
let uploadTask = session.uploadTask(with: newRequest, from: body.data(using: .utf8)) { (data: Data?, response: URLResponse?, error: Error?) in
//    defer {
//        PlaygroundPage.current.finishExecution()
//    }
    response
    error
    guard let data = data else {
        return
    }
    
    let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
}
uploadTask.resume()








let downloadTask = session.downloadTask(with: newUrl) { (file: URL?, response: URLResponse?, error: Error?) in
    defer {
        PlaygroundPage.current.finishExecution()
    }
    response
    error
    
    guard let file = file else { return }
    
    file
    let result = try? NSString(contentsOf: file, encoding: String.Encoding.utf8.rawValue)
}
downloadTask.resume()




























