//
//  NSDate+TimeAgo.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/19/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation

extension Date {
    func timeAgo(numericDates:Bool = true, shortened: Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(self)
        let latest = (earliest == now as Date) ? self : now as Date
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return shortened ? "\(components.year!)y" : "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return shortened ? "1y" : "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return shortened ? "\(components.month!)M" : "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return shortened ? "1m" : "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return shortened ? "\(components.weekOfYear!)w" : "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return shortened ? "1w" : "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return shortened ? "\(components.day!)d" : "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return shortened ? "1d" : "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return shortened ? "\(components.hour!)h" : "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return shortened ? "1h" : "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return shortened ? "\(components.minute!)m" : "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return shortened ? "1m" : "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return shortened ? "\(components.second!)s" : "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
}
