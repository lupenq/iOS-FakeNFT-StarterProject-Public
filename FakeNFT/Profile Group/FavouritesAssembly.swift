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
        let profileService = ProfileService(networkClient: networkClient)
        
        let viewModel = FavouritesViewModel(likedIds: likedIds, nftService: nftService, profileService: profileService)
        
        // Заглушка, пока не создадим соответствующий ViewController
        return UIViewController()
    }
}
