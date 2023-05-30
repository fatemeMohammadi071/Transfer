//
//  TransferListUseCase.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation

protocol TransferListUseCaseProtocol {
    func fetchTransferList(page: Int, completion: @escaping (Result<[TransferData]?, NetworkError>) -> Void)
}

final class TransferListUseCase: TransferListUseCaseProtocol {

    private let transferListRepository: TransferListRepositoryProtocol

    init(transferListRepository: TransferListRepositoryProtocol) {
        self.transferListRepository = transferListRepository
    }

    func fetchTransferList(page: Int, completion: @escaping (Result<[TransferData]?, NetworkError>) -> Void) {
        transferListRepository.getTransferList(page: page) { result in
            completion(result)
        }
    }
}
