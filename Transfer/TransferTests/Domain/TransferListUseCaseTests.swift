//
//  TransferListUseCaseTests.swift
//  TransferTests
//
//  Created by Fateme on 2023-06-06.
//

import XCTest
@testable import Transfer

class TransferListUseCaseTests: XCTestCase {

    struct TransferListRepositoryMock: TransferListRepositoryProtocol {

        var transferResult: (Result<[TransferData]?, NetworkError>)?

        func getTransferList(page: Int, completion: @escaping (Result<[Transfer.TransferData]?, Transfer.NetworkError>) -> Void) {
            guard let transferResult = transferResult else { return }
            completion(transferResult)
        }
    }

    let transfers: [TransferData] = {
        let transfer1 = TransferData.stub(name: "Test1")
        let transfer2 = TransferData.stub(name: "Test2")
        return [transfer1, transfer2]
    }()
    
    func testTransferUseCase_whenSuccessfullyFetcheTransfers_thenTransfersCountIsCorrect() {
        // given
        let expectation = self.expectation(description: "Fetching transfers successed")

        let sut = TransferListUseCase(transferListRepository: TransferListRepositoryMock(transferResult: .success(transfers)))

        // when
        sut.fetchTransferList(page: 1) { result in
            switch result {
            case .success(let transfers):
                XCTAssertEqual(transfers?.count, 2)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not happen")
            }
        }
        // then
        wait(for: [expectation], timeout: 0.1)
    }

    func testTransferUseCase_whenUnsuccessfullyFetcheTransfers_thenTransfrsCountIsIncorrect() {
        // given
        let expectation = self.expectation(description: "Fetching transfers failed")

        let sut = TransferListUseCase(transferListRepository: TransferListRepositoryMock(transferResult: .failure(.noResponse)))

        // when
        sut.fetchTransferList(page: 1) { result in
            switch result {
            case .success:
                XCTFail("Should not happen")
            case .failure:
                expectation.fulfill()
            }
        }
        // then
        wait(for: [expectation], timeout: 0.1)
    }
}

