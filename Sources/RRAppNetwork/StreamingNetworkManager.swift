//
//  StreamingNetworkManager.swift
//  RRAppBaseFrameworks
//
//  Created by Raj S on 30/12/24.
//

import Foundation
import RRAppUtils
import os

// MARK: - NetworkService
public protocol StreamingNetworkService: Actor {
    func setDelegate(_ delegate: StreamingNetworkDelegate)
    func listen(to request: NetworkRequest) async throws -> Int
}

public protocol StreamingNetworkDelegate: AnyObject {
    func didReceive(data: Data, taskId: Int)
}

// MARK: - StreamingNetworkManager
public actor StreamingNetworkManager: NSObject, StreamingNetworkService {
    
    @Inject
    private var config: Config
    private weak var delegate: StreamingNetworkDelegate?
    private let logger = Logger(subsystem: "RRAppBaseFrameworks.StreamingNetworkManager", category: "NetworkManager")
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(
            configuration: config,
            delegate: self,
            delegateQueue: nil
        )
    }()
    
    public func listen(to request: NetworkRequest) throws -> Int {
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
        
        logger.log("\(urlRequest.debugDescription)")
    
        // Create a data task that will receive chunked data
        let task = URLSession.shared.dataTask(with: urlRequest)
        task.resume()
        return task.taskIdentifier
    }
    
    public func setDelegate(_ delegate: StreamingNetworkDelegate) {
        self.delegate = delegate
    }
}

extension StreamingNetworkManager: URLSessionDataDelegate {
    @nonobjc public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        logger.log("urlSession dataTask \(data)")
        self.delegate?.didReceive(data: data, taskId: dataTask.taskIdentifier)
    }
    
    @nonobjc public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: (any Error)?
    ) {
        logger.log("didCompleteWithError \(error)")
    }
}
