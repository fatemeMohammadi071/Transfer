//
//  NetworkManager.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation

final class NetworkManager: NetworkManagerProtocol {

    private let networkLayer: NetworkLayerProtocol

    init(networkLayer: NetworkLayerProtocol = NetworkLayer()) {
        self.networkLayer = networkLayer
    }

    func request<T: RequestProtocol, E: Decodable>(_ request: T,
                                                   completion: @escaping CompletionHandler<E>) {
        networkLayer.request(model: request) { [weak self] response in
            guard let `self` = self else { return }
            switch response {
            case .success(let data):
                let result: Result<E?, NetworkError> = self.decode(data: data)
                completion(result)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func downloadImage<T>(_ request: T, completion: @escaping CompletionHandler<Data>) where T : RequestProtocol {
        networkLayer.request(model: request) { response in
            switch response {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func decode<T: Decodable>(data: Data?) -> Result<T, NetworkError> {
        let decoder = JSONDecoder()
        do {
            guard let data = data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(T.self, from: data)
            return .success(result)
        } catch let error {
            return .failure(.parsing(error))
        }
    }
}
