//
//  RequestMock.swift
//  TransferTests
//
//  Created by Fateme on 2023-06-06.
//

@testable import Transfer

struct RequestMock: RequestProtocol {

    var baseURL: String
    var relativePath: String
    init(relativePath: String) {
        self.relativePath = relativePath
        self.baseURL = "https://dbfead77-66c4-408e-a493-33cb93aa1646.mock.pstmn.io"
    }
}
