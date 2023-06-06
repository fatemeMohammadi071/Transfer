//
//  NetworkManagerTests.swift
//  TransferTests
//
//  Created by Fateme on 2023-06-06.
//

import XCTest
@testable import Transfer

class NetworkManagerTests: XCTestCase {

    func test_whenReceivedValidJsonInResponse_shouldDecodeResponseToDecodableObject() {
        //given
        let expectation = self.expectation(description: "Should decode mock object")
        
        guard let responseData = loadJsonData(fileName: "TransferResponse") else {
            XCTFail("Could not load mock file")
            return
        }
        
        let networkLayer = NetworkLayer(sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                  data: responseData,
                                                                                  error: nil))
        
        let sut = NetworkManager(networkLayer: networkLayer)
        //when
        sut.request(RequestMock(relativePath: "test")) { (result: Result<[TransferResponse]?, NetworkError>) in
            do {
                let object = try result.get()
                XCTAssertEqual(object?.first?.person?.fullName, "Test")
                expectation.fulfill()
            } catch {
                XCTFail("Failed decoding MockObject")
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenInvalidResponse_shouldNotDecodeObject() {
        //given
        let expectation = self.expectation(description: "Should not decode mock object")
        
        guard let responseData = loadJsonData(fileName: "FakeTransferResponse") else {
            XCTFail("Could not load mock file")
            return
        }

        let networkLayer = NetworkLayer(sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                  data: responseData,
                                                                                  error: nil))
        
        let sut = NetworkManager(networkLayer: networkLayer)
        //when
        sut.request(RequestMock(relativePath: "test")) { (result: Result<[TransferResponse]?, NetworkError>) in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                if case NetworkError.parsing = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenNoDataReceived_shouldThrowNoDataError() {
        //given
        let expectation = self.expectation(description: "Should throw no data error")
        
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 200,
                                       httpVersion: "1.1",
                                       headerFields: [:])
        let networkLayer = NetworkLayer(sessionManager: NetworkSessionManagerMock(response: response,
                                                                                  data: nil,
                                                                                  error: nil))
        
        let sut = NetworkManager(networkLayer: networkLayer)
        //when
        sut.request(RequestMock(relativePath: "test")) { (result: Result<[TransferResponse]?, NetworkError>) in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                if case NetworkError.noResponse = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
}
