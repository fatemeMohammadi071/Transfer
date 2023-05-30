//
//  APIEndpoints.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation

enum TransferEndPoint: RequestProtocol {

    case getTransfers(configuration: AppConfiguration, currentPage: Int)
    case downloadImage(configuration: AppConfiguration, path: String)

    var baseURL: String {
        switch self {
        case .getTransfers(let configuration, _):
            return configuration.apiBaseURL
        case .downloadImage(let configuration, _):
            return configuration.imagesBaseURL
        }
    }

    public var relativePath: String {
        switch self {
        case .getTransfers(_, let page):
            return "/transfer-list/\(page)"
        case .downloadImage(_, let path):
             return "/\(path)"
        }
    }
}
