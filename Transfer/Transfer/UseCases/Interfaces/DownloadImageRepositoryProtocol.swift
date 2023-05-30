//
//  DownloadImageRepositoryProtocol.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation

protocol DownloadImageRepositoryProtocol {
    func downloadImage(path: String, completion: @escaping (Result<Data?, NetworkError>) -> Void)
}
