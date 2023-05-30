//
//  TransferDetailsDIContainer.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import UIKit

protocol TransferDetailsDIContainerProtocol {
    func makeTransferDetailsViewController(transfer: TransferData, delgate: TransferDetailsViewControllerProtocol) -> TransferDetailsViewController
    func makeTransferDetailsViewModel(transfer: TransferData) -> TransferDetailsViewModelProtocol
    func makeTransferDetailsFlowCoordinator(navigationController: UINavigationController?) -> TransferDetailsFlowCoordinatorProtocol
}

final class TransferDetailsDIContainer: DefaultAppDIContainer, TransferDetailsDIContainerProtocol {

    func makeTransferDetailsViewController(transfer: TransferData, delgate: TransferDetailsViewControllerProtocol) -> TransferDetailsViewController {
        let vc = TransferDetailsViewController(viewModel: makeTransferDetailsViewModel(transfer: transfer))
        vc.delegate = delgate
        return vc
    }
    
    func makeTransferDetailsViewModel(transfer: TransferData) -> TransferDetailsViewModelProtocol {
        return TransferDetailsViewModel(transfer: transfer, downloadImageUseCase: makeDownloadImageUseCase())
    }

    func makeTransferDetailsFlowCoordinator(navigationController: UINavigationController?) -> TransferDetailsFlowCoordinatorProtocol {
        return TransferDetailsFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension TransferDetailsDIContainer: TransferDetailsFlowCoordinatorDependencies {}
