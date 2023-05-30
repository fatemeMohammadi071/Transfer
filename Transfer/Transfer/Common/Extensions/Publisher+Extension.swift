//
//  Publisher+Extension.swift
//  Github
//
//  Created by Fateme on 2022-11-11.
//

import Foundation
import Combine

extension Publisher {
    func guaranteeMainThread() -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
}
