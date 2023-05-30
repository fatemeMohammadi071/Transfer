//
//  TransferDetailsRepositoryProtocol.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation

protocol TransferDetailsRepositoryProtocol {
    func getTransferDetails(loginId: String, completion: @escaping (Result<TransferData?, NetworkError>) -> Void)
}
