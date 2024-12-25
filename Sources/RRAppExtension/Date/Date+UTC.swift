//
//  Date+UTC.swift
//  RRAppBaseFrameworks
//
//  Created by Raj S on 25/12/24.
//

import Foundation
public extension Date {
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
