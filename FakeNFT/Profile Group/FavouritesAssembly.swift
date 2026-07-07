//
//  FavouritesAssembly.swift
//  FakeNFT
//
//  Created by Данил Третьяченко on 28.06.2026.
//

import UIKit

final class FavouritesAssembly {
    
    static func build(likedIds: [String]) -> UIViewController {
        let networkClient = DefaultNetworkClient()
        let storage = NftStorageImpl()
        let nftService = NftServiceImpl(networkClient: networkClient, storage: storage)
        
        let viewModel = FavouritesViewModel(likedIds: likedIds, nftService: nftService)
        let viewController = FavouritesViewController(viewModel: viewModel)
        
        return viewController
    }
}
