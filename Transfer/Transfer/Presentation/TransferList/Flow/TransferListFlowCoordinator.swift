//
//  TransferListFlowCoordinator.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import UIKit

protocol TransferListFlowCoordinatorProtocol {
    func start()
}

protocol TransferListFlowCoordinatorDependencies  {
    func makeTransferListViewController(action: TransferListViewModelAction) -> TransferListViewController
    func makeTransferDetailsDIContainer() -> TransferDetailsDIContainerProtocol
}

class TransferListFlowCoordinator: TransferListFlowCoordinatorProtocol {

    private weak var navigationController: UINavigationController?
    private let dependencies: TransferListFlowCoordinatorDependencies
    private var transferListViewController: TransferListViewController?

    init(navigationController: UINavigationController,
         dependencies: TransferListFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let action = TransferListViewModelAction(showTransferDetails: showTransferDetails)
        transferListViewController = dependencies.makeTransferListViewController(action: action)
        guard let transferListViewController else { return }
        navigationController?.pushViewController(transferListViewController, animated: false)
    }

    private func showTransferDetails(_ transfer: TransferData) {
        let transferDetailsDIContainer = dependencies.makeTransferDetailsDIContainer()
        let flow = transferDetailsDIContainer.makeTransferDetailsFlowCoordinator(navigationController: navigationController)
        guard let transferListViewController else { return }
        flow.start(transfer: transfer, delgate: transferListViewController)
    }
}
