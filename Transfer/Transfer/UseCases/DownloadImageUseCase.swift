//
//  DownloadImageUseCase.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation

protocol DownloadImageUseCaseProtocol {
    func downloadImage(path: String, completion: @escaping (Result<Data?, NetworkError>) -> Void)
}

final class DownloadImageUseCase: DownloadImageUseCaseProtocol {

    private let downloadImageRepository: DownloadImageRepositoryProtocol

    init(downloadImageRepository: DownloadImageRepositoryProtocol) {
        self.downloadImageRepository = downloadImageRepository
    }

    func downloadImage(path: String, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        let relativePath: String = path.replacingOccurrences(of: "https://www.dropbox.com", with: "")
        return downloadImageRepository.downloadImage(path: relativePath) { result in
            completion(result)
        }
    }
}
