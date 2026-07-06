//
//  MockCurrency.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 23.06.2026.
//

import UIKit

enum MockCurrency {
    static let items: [CurrencyMockData] = [
        .init(image: UIImage(resource: .bitcoinBTC), title: "Bitcoin", shortTitle: "BTC"),
        .init(image: UIImage(resource: .dogecoinDOGE), title: "Dogecoin", shortTitle: "DOGE"),
        .init(image: UIImage(resource: .tetherUSDT), title: "Tether", shortTitle: "USDT"),
        .init(image: UIImage(resource: .apeCoinAPE), title: "ApeCoin", shortTitle: "APE"),
        .init(image: UIImage(resource: .solanaSOL), title: "Solana", shortTitle: "SOL"),
        .init(image: UIImage(resource: .ethereumETH), title: "Ethereum", shortTitle: "ETH"),
        .init(image: UIImage(resource: .cardanoADA), title: "Cardano", shortTitle: "ADA"),
        .init(image: UIImage(resource: .shibaInuSHIB), title: "Shiba Inu", shortTitle: "SHIB")
    ]
}
