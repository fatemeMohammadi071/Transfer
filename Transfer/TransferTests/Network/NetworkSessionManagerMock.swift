//
//  NetworkSessionManagerMock.swift
//  TransferTests
//
//  Created by Fateme on 2023-06-06.
//

import Foundation
@testable import Transfer

struct NetworkSessionManagerMock: NetworkSessionManagerProtocol {
    var response: HTTPURLResponse?
    var data: Data?
    var error: Error?
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> Cancellable {
        completion(data, response, error)
        return URLSessionDataTask()
    }
}
