//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import XCPlayground

PlaygroundPage.current.needsIndefiniteExecution = true

let configuration = URLSessionConfiguration.default

let session = URLSession(configuration: configuration)

let url = URL(string: "https://api.chucknorris.io/jokes/random")!


let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
    guard let data = data else {
        print(error ?? "data and error not available")
        return
    }
    
    let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
    PlaygroundPage.current.finishExecution()
}

task.resume()
