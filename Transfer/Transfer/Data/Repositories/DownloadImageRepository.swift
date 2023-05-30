//
//  DownloadImageRepository.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation

final class DownloadImageRepository: DownloadImageRepositoryProtocol {

    private let networkManager: NetworkManagerProtocol
    private let configuration: AppConfiguration

    init(networkManager: NetworkManagerProtocol, configuration: AppConfiguration) {
        self.networkManager = networkManager
        self.configuration = configuration
    }

    func downloadImage(path: String, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        networkManager.downloadImage(TransferEndPoint.downloadImage(configuration: configuration, path: path)) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
