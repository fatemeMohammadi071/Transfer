//
//  XCTest+Extension.swift
//  TransferTests
//
//  Created by Fateme on 2023-06-06.
//

import XCTest
import Foundation
@testable import Transfer

extension XCTestCase {

    func loadMock(fileName: String, ofType: String = "json") -> String? {
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: ofType) else {
            return nil
        }
        return try? String(contentsOfFile:path, encoding: .utf8)
    }

    func loadJsonData(fileName: String) -> Data? {
        if let json = loadMock(fileName: fileName), let data = json.data(using: .utf8) {
            return data
        }
        return nil
    }

    func waitUntil(delay: Double? = 0, timeout: Double, action: @escaping ((@escaping () -> ()) -> ())) {
        let __expectation = XCTestExpectation(description: "waitUntil")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(delay ?? 0)) {
            action {
                __expectation.fulfill()
            }
        }
        wait(for: [__expectation], timeout: TimeInterval(timeout + (delay ?? 0)))
    }
}
