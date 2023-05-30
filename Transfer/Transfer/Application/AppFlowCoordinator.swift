//
//  AppFlowCoordinator.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import UIKit

protocol AppFlowCoordinatorProtocol {
    func start()
}

final class AppFlowCoordinator: AppFlowCoordinatorProtocol {

    private let navigationController: UINavigationController
    private let appDIContainer: AppDIContainerProtocol

    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainerProtocol) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let transferListDIContainer = appDIContainer.makeTransferListDIContainer()
        let flow = transferListDIContainer.makeTransferListFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
