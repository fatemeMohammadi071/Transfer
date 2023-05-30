//
//  TransferListRepository.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation
 
final class TransferListRepository: TransferListRepositoryProtocol {

    private let networkManager: NetworkManagerProtocol
    private let configuration: AppConfiguration
    
    init(networkManager: NetworkManagerProtocol, configuration: AppConfiguration) {
        self.networkManager = networkManager
        self.configuration = configuration
    }
    
    func getTransferList(page: Int, completion: @escaping (Result<[TransferData]?, NetworkError>) -> Void) {
        networkManager.request(TransferEndPoint.getTransfers(configuration: configuration, currentPage: page)) { (result: Result<TransfersResponse?, NetworkError>) in
            switch result {
            case .success(let transfers):
                let transfers = transfers?.compactMap { $0.toDomain() }
                completion(.success(transfers))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
