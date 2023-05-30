//
//  RequestProtocol.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
}

protocol RequestProtocol {
    var baseURL: String {get}
    var relativePath: String {get}
    var method: HTTPMethods {get}
    var headers: [String: String]? {get}
    var parameters: [String: Any]? {get}
}

extension RequestProtocol {
    var baseURL: String {
        return "https://api.github.com"
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var parameters: [String: Any]? {
        return [:]
    }

    var method: HTTPMethods {
        return .get
    }
}
