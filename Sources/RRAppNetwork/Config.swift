//
//  Config.swift
//  ChatGPTChat
//
//  Created by Raj S on 28/01/24.
//

import Foundation
import RRAppUtils

// MARK: - Config
public protocol Config {
    var apiBasePath: String { get }
    var appToken: String { get }
}

public struct ConfigMock: Config {
    public let apiBasePath: String = ""
    public let appToken: String = ""
    
    public init() {}
}
