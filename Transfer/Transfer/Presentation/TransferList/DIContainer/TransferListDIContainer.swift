//
//  TransferListDIContainer.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import UIKit

protocol TransferListDIContainerProtocol {
    func makeTransferListViewController(action: TransferListViewModelAction) -> TransferListViewController
    func makeTransferListViewModel(action: TransferListViewModelAction) -> TransferListViewModelProtocol
    func makeTransferListRepository() -> TransferListRepositoryProtocol
    func makeTransferListUseCase() -> TransferListUseCaseProtocol
    func makeTransferListFlowCoordinator(navigationController: UINavigationController) -> TransferListFlowCoordinatorProtocol
}

protocol DownloadImageDIContainerProtocol {
    func makeDownloadImageRepository() -> DownloadImageRepositoryProtocol
    func makeDownloadImageUseCase() -> DownloadImageUseCaseProtocol
}

final class TransferListDIContainer: DefaultAppDIContainer, TransferListDIContainerProtocol {

    func makeTransferListViewController(action: TransferListViewModelAction) -> TransferListViewController {
        return TransferListViewController(viewModel: makeTransferListViewModel(action: action), downloadImageUseCase: makeDownloadImageUseCase())
    }

    func makeTransferListViewModel(action: TransferListViewModelAction) -> TransferListViewModelProtocol {
        return TransferListViewModel(transferListUseCase: makeTransferListUseCase(), action: action)
    }

    func makeTransferListRepository() -> TransferListRepositoryProtocol {
        return TransferListRepository(networkManager: networkManager, configuration: configuration)
    }

    func makeTransferListUseCase() -> TransferListUseCaseProtocol {
        return TransferListUseCase(transferListRepository: makeTransferListRepository())
    }

    func makeTransferListFlowCoordinator(navigationController: UINavigationController) -> TransferListFlowCoordinatorProtocol {
        return TransferListFlowCoordinator(navigationController: navigationController, dependencies: self)
    }

    func makeTransferDetailsDIContainer() -> TransferDetailsDIContainerProtocol {
        return TransferDetailsDIContainer()
    }

}

extension TransferListDIContainer: TransferListFlowCoordinatorDependencies {}
