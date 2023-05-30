//
//  Collection+Extension.swift
//  Github
//
//  Created by Fateme on 2022-11-11.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
