//
//  MockData.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 19.06.2026.
//

import UIKit

enum MockData {
    static let items: [NFTItem] = [
        NFTItem(image: UIImage(resource: .nft1), title: "April", rating: 1, price: 1.78),
        NFTItem(image: UIImage(resource: .nft2), title: "Greena", rating: 3, price: 1.78),
        NFTItem(image: UIImage(resource: .nft3), title: "Spring", rating: 5, price: 1.78)
    ]
}
