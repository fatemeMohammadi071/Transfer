//
//  TransferDetailsViewModel.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation
import Combine

protocol TransferDetailsViewModelProtocol {
    // input
    func viewDidLoad()
    
    // output
    var transfer$: AnyPublisher<TransferData, Never> { get }
    var imageData$: AnyPublisher<Data?, Never> { get }
}

class TransferDetailsViewModel: TransferDetailsViewModelProtocol {

    var transfer$: AnyPublisher<TransferData, Never> {
        transferSubject.guaranteeMainThread()
    }

    var imageData$: AnyPublisher<Data?, Never> {
        imageDatatSubject.guaranteeMainThread()
    }

    var transferSubject = PassthroughSubject<TransferData, Never>()

    var imageDatatSubject = PassthroughSubject<Data?, Never>()

    private var transfer: TransferData

    private let downloadImageUseCase: DownloadImageUseCaseProtocol?

    init(transfer: TransferData, downloadImageUseCase: DownloadImageUseCaseProtocol?) {
        self.transfer = transfer
        self.downloadImageUseCase = downloadImageUseCase
    }

    func viewDidLoad() {
        self.transferSubject.send(transfer)
        self.downloadImageWith(transfer.avatarPath)
    }

    func downloadImageWith(_ path: String?) {
        guard let path = path else { return }
        downloadImageUseCase?.downloadImage(path: path) { [weak self] result in
            switch result {
            case .success(let data):
                self?.imageDatatSubject.send(data)
            case .failure: break
            }
        }
    }
}
