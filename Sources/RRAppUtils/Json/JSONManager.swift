//
//  JSONManager.swift
//  RRAppBaseFrameworks
//
//  Created by Raj S on 25/12/24.
//

import Foundation

/// Helper class to convert json data
public struct JSONManager {
    
    /// Return a dictionary from the data
    ///
    /// - Parameter dictionaryAsData: data object to convert
    /// - Returns: dictonary of string to string
    public static func dictionaryFromData(_ dictionaryAsData: Data?) throws -> [String: Any] {
        guard let dictionaryAsData = dictionaryAsData else {
            throw NSError(domain: "Data is null", code: -422)
        }
        
        let decoded = try JSONSerialization.jsonObject(with: dictionaryAsData, options: [])
        return decoded as? [String: Any] ?? [:]
    }
    
    /// Return a data from json dictionary
    ///
    /// - Parameter dictionary: Dictionary representation of json
    /// - Returns: data object with the json
    public static func dataFromDictionary(_ dictionary: [String: Any]?) throws -> Data {
        guard let dictionary = dictionary else {
            throw NSError(domain: "Dictionary is nill", code: -422)
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        return jsonData
    }
    
    /// Return String from json
    ///
    /// - Parameter json: json
    /// - Parameter prettyPrinted : printing style default to false
    /// - Returns: data object with the json
    public static func stringify(json: Any, prettyPrinted: Bool = false) throws -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
            options = JSONSerialization.WritingOptions.prettyPrinted
        }
        
        let data = try JSONSerialization.data(withJSONObject: json, options: options)
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
        } else {
            throw NSError(domain: "Can't generate string file", code: -422)
        }
    }
    
    public static func jsonStringFromDictionary(dict : Any) throws -> String {
        let theJSONData = try JSONSerialization.data(
            withJSONObject: dict,
            options: []
        )
        
        guard let string = String(data: theJSONData, encoding: .utf8) else {
            throw NSError(domain: "Can't generate string file", code: -412)
        }
        
        return string
    }
    
    public static func dictionaryFromJSONString(string : String) throws -> Dictionary<String,Any> {
        let data = string.data(using: .utf8)!
        guard let dict = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any> else {
            throw NSError(domain: "Can't generate dict", code: -412)
        }
        
        return dict
    }
    
    public static func fetchData<T: Decodable>(fileName : String,from bundle: Bundle) throws -> T {
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {
            throw NSError(domain: "File is not found", code: -422)
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let model = try JSONDecoder().decode(T.self, from: data)
        return model
    }
}
