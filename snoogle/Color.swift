//
//  Color.swift
//  snoogle
//
//  Created by Vincent Moore on 10/7/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm
import UIKit

class Color: Object {
    dynamic var red: Double = 0
    dynamic var green: Double = 0
    dynamic var blue: Double = 0
    dynamic var alpha: Double = 1.0
    dynamic var id: String = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func create(color: UIColor) -> Color {
        let ciColor = CIColor(color: color)
        let realmColor = Color()
        realmColor.red = Double(ciColor.red)
        realmColor.green = Double(ciColor.green)
        realmColor.blue = Double(ciColor.blue)
        realmColor.alpha = Double(ciColor.alpha)
        return realmColor
    }
    
    func getColor() -> UIColor {
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
}
