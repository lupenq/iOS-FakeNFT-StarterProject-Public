//
//  ModelsProfile.swift
//  FakeNFT
//
//  Created by Данил Третьяченко on 28.06.2026.
//

import Foundation

struct Profile: Codable {
    let id: String
    let name: String
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]
    let likes: [String]
}
