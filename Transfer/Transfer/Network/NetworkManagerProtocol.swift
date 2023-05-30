//
//  NetworkManagerProtocol.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation

protocol NetworkManagerProtocol {
    typealias CompletionHandler<T> = ((Result<T?, NetworkError>) -> Void)

    func request<T: RequestProtocol, E: Decodable>(_ request: T,
                                                   completion: @escaping CompletionHandler<E>)
    func downloadImage<T: RequestProtocol>(_ request: T,
                                                   completion: @escaping CompletionHandler<Data>)
}
