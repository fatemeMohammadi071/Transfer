//
//  stubs.swift
//  TransferTests
//
//  Created by Fateme on 2023-06-06.
//

import Foundation
@testable import Transfer

extension TransferResponse {
    static func stub(person: Person?, card: Card?, lastTransfer: String?, note: String?, moreInfo: MoreInfo?) -> Self {
       TransferResponse(person: person, card: card, lastTransfer: lastTransfer, note: note, moreInfo: moreInfo)
    }
}

extension TransferData {
    static func stub(name: String?, avatarPath: String? = "", card: Card? = Card(cardNumber: "", cardType: ""), moreInfo: MoreInfo? = MoreInfo(numberOfTransfers: 0, totalTransfer: 0), note: String? = "") -> Self {
        TransferData(name: name, avatarPath: avatarPath, card: card, moreInfo: moreInfo, note: note)
    }
}
