//
//  OrderUpdateDto.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 01.07.2026.
//

import Foundation

struct OrderUpdateDto: Dto {
    let nfts: [String]
    
    func asDictionary() -> [String : String] {
        ["nfts": nfts.joined(separator: ",")]
    }
}
