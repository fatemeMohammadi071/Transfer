//
//  appDIContainer.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import UIKit

protocol AppDIContainerProtocol {
    func makeTransferListDIContainer() -> TransferListDIContainerProtocol
    func makeAppFlowCoordinator(navigationController: UINavigationController) -> AppFlowCoordinatorProtocol
}

final class AppDIContainer: DefaultAppDIContainer, AppDIContainerProtocol {

    func makeTransferListDIContainer() -> TransferListDIContainerProtocol {
        return TransferListDIContainer()
    }

    func makeAppFlowCoordinator(navigationController: UINavigationController) -> AppFlowCoordinatorProtocol {
        return AppFlowCoordinator(navigationController: navigationController, appDIContainer: self)
    }
}
