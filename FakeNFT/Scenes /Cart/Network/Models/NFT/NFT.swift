//
//  NFT.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 02.07.2026.
//

import Foundation

struct NFT: Decodable {
    let id: String
    let name: String
    let price: Double
    let imageUrl: URL?
    let rating: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, price, rating
        case images
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Double.self, forKey: .price)
        rating = try container.decodeIfPresent(Int.self, forKey: .rating) ?? 0
        
        if let urls = try container.decodeIfPresent([String].self, forKey: .images) {
            imageUrl = URL(string: urls.first ?? "")
        } else {
            imageUrl = nil
        }
    }
}
