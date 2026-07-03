//
//  OrderResponse.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 01.07.2026.
//

import Foundation

struct OrderResponse: Decodable {
    let id: String
    let nfts: [String]
    
}
