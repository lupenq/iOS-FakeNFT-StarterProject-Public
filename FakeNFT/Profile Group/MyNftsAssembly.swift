//
//  MyNftsAssembly.swift
//  FakeNFT
//
//  Created by Данил Третьяченко on 28.06.2026.
//

import UIKit

final class MyNftsAssembly {
    
    static func build(nftIds: [String]) -> UIViewController {
        let networkClient = DefaultNetworkClient()
        let storage = NftStorageImpl()
        let nftService = NftServiceImpl(networkClient: networkClient, storage: storage)
        
        let viewModel = MyNftsViewModel(nftIds: nftIds, nftService: nftService)
        
        // Заглушка, пока не создадим соответствующий ViewController
        return UIViewController()
    }
}
