//
//  AppEncoderAndDecoder.swift
//  RRAppBaseFrameworks
//
//  Created by Raj S on 25/12/24.
//

import Foundation
import RRAppExtension

public struct AppEncoderAndDecoder : Sendable {
    public static let shared = AppEncoderAndDecoder()
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    let localeStr = "en_US_POSIX"
    
    private init() {
        encoder.dateEncodingStrategy = .custom({ (date, encoder) in
            var container = encoder.singleValueContainer()
            let df = DateFormatter.formatter(DateFormats.fullFormatWithMilliSeconds.rawValue)
            df.timeZone = TimeZone(abbreviation: "UTC")
            let dateStr = df.string(from: date)
            try? container.encode(dateStr)
        })
        
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try? container.decode(String.self)
            return DateExtractor.extractDateIfPossible(from: dateStr ?? "") ?? Date()
        })
    }

    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        return try self.decoder.decode(type, from: data)
    }

    public func encode<T>(_ value: T) throws -> Data where T: Encodable {
        return try self.encoder.encode(value)
    }

    public func encodeAndGetDict<T>(_ value: T) throws -> [String: Any]? where T: Encodable {
        let encodedData = try self.encoder.encode(value)
        return try JSONSerialization.jsonObject(with: encodedData, options: []) as? [String: Any]
    }

    public func encodeAndGetArray<T>(_ value: T) throws -> [[String: Any]]? where T: Encodable {
        let encodedData = try self.encoder.encode(value)
        return try JSONSerialization.jsonObject(with: encodedData, options: []) as? [[String: Any]]
    }
}

struct DateExtractor {
    static let dateFormats: [DateFormats] = [
        DateFormats.fullFormatWithMilliSeconds,
        DateFormats.fullFormat,
        DateFormats.yearMonthDayWithDashes,
        DateFormats.monthDayYearWithSpaces,
        DateFormats.fullFormatWithoutMilliSeconds
    ]
    
    static func extractDateIfPossible(from dateStr: String) -> Date? {
        let df = DateFormatter.formatter(DateFormats.fullFormatWithMilliSeconds.rawValue)
        
        for format in dateFormats {
            df.dateFormat = format.rawValue
            df.timeZone = TimeZone.current
            if let date = df.date(from: dateStr) {
                return date.toLocalTime()
            }
        }
        
        return nil
    }
}
