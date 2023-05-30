//
//  TransferListViewModel.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation
import Combine

struct TransferListViewModelAction {
    let showTransferDetails: (TransferData) -> Void
}

protocol TransferListViewModelProtocol {
    //input
    func viewDidLoad()
    func loadMoreData(page: Int)
    func didSelectItemWith(_ trasnfer: TransferData)

    // output
    var error$: AnyPublisher<NetworkError, Never> { get }
    var items$: AnyPublisher<[TransferData], Never> { get }
    var isEmptyList$: AnyPublisher<Void, Never> { get }
    var isLoading$: AnyPublisher<Bool, Never> { get }
    var canLoadMore: AnyPublisher<Bool, Never> { get }
}

class TransferListViewModel: TransferListViewModelProtocol {

    var error$: AnyPublisher<NetworkError, Never> {
        errorSubject.guaranteeMainThread()
    }

    var items$: AnyPublisher<[TransferData], Never> {
        itemsSubject.guaranteeMainThread()
    }

    var isEmptyList$: AnyPublisher<Void, Never> {
        isEmptyListSubject.guaranteeMainThread()
    }

    var isLoading$: AnyPublisher<Bool, Never>  {
        isLoadingSubject.guaranteeMainThread()
    }

    var canLoadMore: AnyPublisher<Bool, Never> {
        canLoadMoreSubject.guaranteeMainThread()
    }

    var errorSubject = PassthroughSubject<NetworkError, Never>()

    var itemsSubject = PassthroughSubject<[TransferData], Never>()

    var isEmptyListSubject = PassthroughSubject<Void, Never>()

    var isLoadingSubject = PassthroughSubject<Bool, Never>()

    var canLoadMoreSubject = PassthroughSubject<Bool, Never>()

    private let transferListUseCase: TransferListUseCaseProtocol

    private var action: TransferListViewModelAction?

    init(transferListUseCase: TransferListUseCaseProtocol, action: TransferListViewModelAction?) {
        self.transferListUseCase = transferListUseCase
        self.action = action
    }

    func viewDidLoad() {
        loadData()
    }

    func loadData() {
        isLoadingSubject.send(true)
        fetchData(page: 1) { [weak self] result in
            guard let self = self else { return }
            self.isLoadingSubject.send(false)
            switch result {
            case .success(let transfers):
                guard let transfers = transfers, !transfers.isEmpty else {
                    self.isEmptyListSubject.send()
                    self.canLoadMoreSubject.send(false)
                    return
                }
                self.itemsSubject.send(transfers)
            case .failure(let error):
                self.errorSubject.send(error)
            }
        }
    }

    func loadMoreData(page: Int) {
        fetchData(page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let transfers):
                guard let transfers = transfers, !transfers.isEmpty else {
                    self.canLoadMoreSubject.send(false)
                    return
                }
                self.canLoadMoreSubject.send(true)
                self.itemsSubject.send(transfers)
            case .failure(let error):
                self.errorSubject.send(error)
            }
        }
    }

    func fetchData(page: Int, completion: @escaping (Result<[TransferData]?, NetworkError>) -> Void) {
        transferListUseCase.fetchTransferList(page: page) { result in
            switch result {
            case .success(let transfers):
                completion(.success(transfers))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func didSelectItemWith(_ trasnfer: TransferData) {
        action?.showTransferDetails(trasnfer)
    }
}
