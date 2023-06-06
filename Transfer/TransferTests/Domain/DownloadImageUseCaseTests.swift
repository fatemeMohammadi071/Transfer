//
//  DownloadImageUseCaseTests.swift
//  TransferTests
//
//  Created by Fateme on 2023-06-06.
//

import XCTest
@testable import Transfer

class DownloadImageUseCaseTests: XCTestCase {

    struct DownloadImageRepositoryMock: DownloadImageRepositoryProtocol {
    
        var ImageResult: (Result<Data?, NetworkError>)?

        func downloadImage(path: String, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
            guard let ImageResult = ImageResult else { return }
            completion(ImageResult)
        }
    }

    func testUserUseCase_whenSuccessfullyDownloadImage_thenImageDataHasValue() {
        // given
        let expectation = self.expectation(description: "Downloading image successed")

        let sut = DownloadImageUseCase(downloadImageRepository: DownloadImageRepositoryMock(ImageResult:  .success(Data())))

        // when
        sut.downloadImage(path: "test.com") { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not happen")
            }
        }
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testUserUseCase_whenUnsuccessfullyDownloadImage_thenImageDataHasNotValue() {
        // given
        let expectation = self.expectation(description: "Downloading image failed")

        let sut = DownloadImageUseCase(downloadImageRepository: DownloadImageRepositoryMock(ImageResult:  .failure(.noResponse)))

        // when
        sut.downloadImage(path: "test.com") { result in
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
