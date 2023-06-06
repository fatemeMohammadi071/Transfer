//
//  NetwokLayerTests.swift
//  TransferTests
//
//  Created by Fateme on 2023-06-06.
//

import XCTest
@testable import Transfer

class NetwokLayerTests: XCTestCase {

    private enum NetworkErrorMock: Error {
        case someError
    }

    func test_whenMockDataPassed_shouldReturnProperResponse() {
        //given
        let expectation = self.expectation(description: "Should return correct data")
        
        let expectedResponseData = "Response data".data(using: .utf8)!
        let sut = NetworkLayer(sessionManager: NetworkSessionManagerMock(response: nil,
                                                                         data: expectedResponseData,
                                                                         error: nil))
        //when
        sut.request(model: RequestMock(relativePath: "test")) { result in
            guard let responseData = try? result.get() else {
                XCTFail("Should return proper response")
                return
            }
            XCTAssertEqual(responseData, expectedResponseData)
            expectation.fulfill()
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenErrorWithNSURLErrorCancelledReturned_shouldReturnCancelledError() {
        //given
        let expectation = self.expectation(description: "Should return hasStatusCode error")
        
        let cancelledError = NSError(domain: "network", code: NSURLErrorCancelled, userInfo: nil)
        let sut = NetworkLayer(sessionManager: NetworkSessionManagerMock(response: nil,
                                                                         data: nil,
                                                                         error: cancelledError as Error))
        //when
        sut.request(model: RequestMock(relativePath: "test")) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                guard case NetworkError.cancelled = error else {
                    XCTFail("NetworkError.cancelled not found")
                    return
                }
                
                expectation.fulfill()
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }

    func test_whenStatusCodeEqualOrAbove400_shouldReturnhasStatusCodeError() {
        //given
        let expectation = self.expectation(description: "Should return hasStatusCode error")
        
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 500,
                                       httpVersion: "1.1",
                                       headerFields: [:])
        let sut = NetworkLayer(sessionManager: NetworkSessionManagerMock(response: response,
                                                                         data: nil,
                                                                         error: NetworkErrorMock.someError))
        //when
        sut.request(model: RequestMock(relativePath: "test")) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                if case NetworkError.error(let statusCode, _) = error {
                    XCTAssertEqual(statusCode, 500)
                    expectation.fulfill()
                }
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenErrorWithNSURLErrorNotConnectedToInternetReturned_shouldReturnNotConnectedError() {
        //given
        let expectation = self.expectation(description: "Should return hasStatusCode error")
        
        let error = NSError(domain: "network", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        let sut = NetworkLayer(sessionManager: NetworkSessionManagerMock(response: nil,
                                                                         data: nil,
                                                                         error: error as Error))
        
        //when
        sut.request(model: RequestMock(relativePath: "test")) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                guard case NetworkError.notConnected = error else {
                    XCTFail("NetworkError.notConnected not found")
                    return
                }
                
                expectation.fulfill()
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
}
