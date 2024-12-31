//
//  StreamingNetworkManager.swift
//  RRAppBaseFrameworks
//
//  Created by Raj S on 30/12/24.
//

import Foundation
import RRAppUtils

// MARK: - NetworkService
public protocol StreamingNetworkService {
    var urlSessionDataDelegate: URLSessionDataDelegateHolder { get }
    func listen(to request: NetworkRequest) throws -> Int
}


public final class StreamingNetworkManager: StreamingNetworkService {
    
    @Inject
    private var config: Config
    
    public let urlSessionDataDelegate = URLSessionDataDelegateHolder()
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(
            configuration: config,
            delegate: urlSessionDataDelegate,
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
    
        // Create a data task that will receive chunked data
        let task = URLSession.shared.dataTask(with: urlRequest)
        task.resume()
        return task.taskIdentifier
    }
}

public actor URLSessionDataDelegateHolder: NSObject, URLSessionDataDelegate {
    
    private var didReceive: ((URLSessionDataTask, Data) -> Void)?
    
    @nonobjc public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        didReceive?(dataTask, data)
    }
    
    public func setDidReceive(
        _ closure: @escaping (URLSessionDataTask, Data) -> Void
    ) {
        self.didReceive = closure
    }
}

