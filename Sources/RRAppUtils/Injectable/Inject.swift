//
//  Inject.swift
//  ChatGPTChat
//
//  Created by Raj S on 28/01/24.
//

import Foundation

// MARK: - Inject
@propertyWrapper
public struct Inject<T> {
    public let wrappedValue: T
    
    public init() {
        wrappedValue = Resolver.shared.resolve()
    }
}

// MARK: - Resolver
public class Resolver {
    private var storage = [String: AnyObject]()
    
    nonisolated(unsafe) public static let shared = Resolver()
    private init() {}
    
    public func add<T>(_ injectable: T,key: String) {
        storage[key] = injectable as AnyObject
    }

    public func resolve<T>() -> T {
        let key = String(reflecting: T.self)
        guard let injectable = storage[key] as? T else {
            fatalError("\(key) has not been added as an injectable object.")
        }
        
        return injectable
    }
}
