//
//  TransferDetailsFlowCoordinator.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import UIKit

protocol TransferDetailsFlowCoordinatorProtocol {
    func start(transfer: TransferData, delgate: TransferDetailsViewControllerProtocol)
}

protocol TransferDetailsFlowCoordinatorDependencies  {
    func makeTransferDetailsViewController(transfer: TransferData, delgate: TransferDetailsViewControllerProtocol) -> TransferDetailsViewController
}

class TransferDetailsFlowCoordinator: TransferDetailsFlowCoordinatorProtocol {

    private weak var navigationController: UINavigationController?
    private let dependencies: TransferDetailsFlowCoordinatorDependencies

    init(navigationController: UINavigationController?,
         dependencies: TransferDetailsFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start(transfer: TransferData, delgate: TransferDetailsViewControllerProtocol) {
        let vc = dependencies.makeTransferDetailsViewController(transfer: transfer, delgate: delgate)
        navigationController?.pushViewController(vc, animated: false)
    }
}
