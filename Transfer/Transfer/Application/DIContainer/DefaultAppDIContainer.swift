//
//  DefaultAppDIContainer.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation

protocol DefaultAppDIContainerProtocol: DownloadImageDIContainerProtocol {}

class DefaultAppDIContainer: DefaultAppDIContainerProtocol {
    lazy var networkManager: NetworkManagerProtocol = NetworkManager()
    lazy var configuration: AppConfiguration = AppConfiguration()
    
    func makeDownloadImageRepository() -> DownloadImageRepositoryProtocol {
        return DownloadImageRepository(networkManager: networkManager, configuration: configuration)
    }
    
    func makeDownloadImageUseCase() -> DownloadImageUseCaseProtocol {
        return DownloadImageUseCase(downloadImageRepository: makeDownloadImageRepository())
    }
}
