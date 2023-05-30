//
//  NetworkLayer.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation

enum NetworkError: Error {
    case notConnected
    case cancelled
    case generic(Error)
    case parsing(Error)
    case noResponse
    case error(statusCode: Int, data: Data?)
}

protocol Cancellable {
    func cancelRequest()
}

extension URLSessionDataTask: Cancellable {
    func cancelRequest() {
        cancel()
    }
}

protocol NetworkLayerProtocol {
    @discardableResult
    func request(model: RequestProtocol,
                 completion: @escaping (_ response: Result<Data?, NetworkError>) -> Void) -> Cancellable?
}

typealias DataTaskResult = Result<Data?, NetworkError>

class NetworkLayer: NetworkLayerProtocol {

    var dataTask: URLSessionDataTask?

    private let sessionManager: NetworkSessionManagerProtocol

    init(sessionManager: NetworkSessionManagerProtocol = NetworkSessionManager()) {
        self.sessionManager = sessionManager
    }

    @discardableResult
    func request(model: RequestProtocol, completion: @escaping (DataTaskResult) -> Void) -> Cancellable? {
        dataTask?.cancel()
        guard let url = URL(string: model.baseURL + model.relativePath) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = model.method.rawValue
        let dataTask = sessionManager.request(request) { (data,response,error)   in
            guard let error = error else { return completion(.success(data)) }
            let networkError: NetworkError
            if let response = response as? HTTPURLResponse {
                networkError = .error(statusCode: response.statusCode, data: data)
            } else {
                networkError = self.resolve(error: error)
            }
            completion(.failure(networkError))
        }
        return dataTask
    }

    private func resolve(error: Error, response: HTTPURLResponse? = nil) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        print("This is error: \(error) , Code: \(code)")
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}
