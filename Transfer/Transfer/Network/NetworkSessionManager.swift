//
//  NetworkSessionManager.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation

protocol NetworkSessionManagerProtocol {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> Cancellable
}

class NetworkSessionManager: NetworkSessionManagerProtocol {
    func request(_ request: URLRequest,
                        completion: @escaping CompletionHandler) -> Cancellable {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}
