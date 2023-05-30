//
//  TransferData.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation

struct TransferData {
    let identifier = UUID()
    let name: String?
    let avatarPath: String?
    let card: Card?
    let moreInfo: MoreInfo?
    let note: String?
    var isFav: Bool? = false
}
