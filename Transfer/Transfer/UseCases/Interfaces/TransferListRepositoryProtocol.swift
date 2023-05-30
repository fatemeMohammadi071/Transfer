//
//  TransferListRepositoryProtocol.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation

protocol TransferListRepositoryProtocol {
    func getTransferList(page: Int, completion: @escaping (Result<[TransferData]?, NetworkError>) -> Void)
}
