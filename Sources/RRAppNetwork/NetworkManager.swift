//
//  NetworkManager.swift
//  ChatGPTChat
//
//  Created by Raj S on 28/01/24.
//

import Foundation
import RRAppUtils

// MARK: - NetworkService
public protocol NetworkService {
    func perform<T: Decodable>(
        request: NetworkRequest
    ) async throws -> T
}

// MARK: - URLSessionNetworkManager
public class URLSessionNetworkManager: NetworkService {
    
    public init() {}
    
    @Inject
    var config: Config
    
    public func perform<T: Decodable>(
        request: NetworkRequest
    ) async throws -> T {
        guard let url = URL(string: config.apiBasePath + "/" + request.path) else {
            throw NetworkError.invalidUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(config.appToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        for header in request.additionalHeader {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        urlRequest.httpMethod = request.method.rawValue
        
        let jsonData = try JSONSerialization.data(withJSONObject: request.body ?? [:], options: [])
        urlRequest.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
}

// MARK: - NetworkError
public enum NetworkError: LocalizedError {
    case invalidUrl
    case invalidResponse
    
    public var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return NSLocalizedString("Invalid Url", comment: "")
        case .invalidResponse:
            return NSLocalizedString("Invalid Response", comment: "")
        }
    }
}

// MARK: - NetworkRequest
public struct NetworkRequest {
    public enum Method: String {
        case post = "POST"
        case get = "GET"
    }
    
    public typealias BodyParams = [String: Any]
    
    public let method: Method
    public let path: String
    public let body: BodyParams?
    public let additionalHeader: [String: String]
    
    public init(
        method: Method,
        path: String,
        body: BodyParams?,
        additionalHeader: [String: String] = [:]
    ) {
        self.method = method
        self.path = path
        self.body = body
        self.additionalHeader = additionalHeader
    }
}

// MARK: - NetworkServiceMock
public struct NetworkServiceMock: NetworkService {
    public func perform<T>(request: NetworkRequest) async throws -> T where T : Decodable {
        throw NetworkError.invalidResponse
    }
    
    public static func add() {
        Resolver.shared.add(NetworkServiceMock(),key: String(reflecting: NetworkService.self))
    }
}
