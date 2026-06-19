//
//  NFTItem.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 19.06.2026.
//

import UIKit

struct NFTItem {
    let id: UUID = UUID()
    let image: UIImage?
    let title: String
    var rating: Int
    let price: Double
}
