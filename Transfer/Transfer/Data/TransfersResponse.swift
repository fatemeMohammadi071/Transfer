//
//  UsersResponse.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import Foundation

import Foundation

typealias TransfersResponse = [TransferResponse]

// MARK: - WelcomeElement
struct TransferResponse: Codable {
    let person: Person?
    let card: Card?
    let lastTransfer: String?
    let note: String?
    let moreInfo: MoreInfo?

    enum CodingKeys: String, CodingKey {
        case person, card
        case lastTransfer = "last_transfer"
        case note
        case moreInfo = "more_info"
    }
}

// MARK: - Card
struct Card: Codable {
    let cardNumber, cardType: String

    enum CodingKeys: String, CodingKey {
        case cardNumber = "card_number"
        case cardType = "card_type"
    }
}

// MARK: - MoreInfo
struct MoreInfo: Codable {
    let numberOfTransfers, totalTransfer: Int

    enum CodingKeys: String, CodingKey {
        case numberOfTransfers = "number_of_transfers"
        case totalTransfer = "total_transfer"
    }
}

// MARK: - Person
struct Person: Codable {
    let fullName: String
    let email: String?
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case email, avatar
    }
}

extension TransferResponse {
    func toDomain() -> TransferData {
        return .init(name: person?.fullName, avatarPath: person?.avatar, card: card, moreInfo: moreInfo, note: note)
    }
}
