//
//  File.swift
//  RRAppBaseFrameworks
//
//  Created by Raj S on 25/12/24.
//

import Foundation
public extension Formatter {
    static func formatter(_ format : String) -> DateFormatter  {
        let formatter = DateFormatter()
        let localeStr = "en_US_POSIX"
        formatter.locale = Locale(identifier: localeStr)
        formatter.dateFormat = format
        return formatter
    }
}

