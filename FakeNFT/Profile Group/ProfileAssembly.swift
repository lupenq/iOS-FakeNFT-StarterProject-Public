//
//  ProfileAssembly.swift
//  FakeNFT
//
//  Created by Данил Третьяченко on 28.06.2026.
//

import UIKit

final class ProfileAssembly {
    
    func build() -> UIViewController {
        let networkClient = DefaultNetworkClient()
        let profileService = ProfileService(networkClient: networkClient)
        let viewModel = ProfileViewModel(profileService: profileService)
        
        // Временная заглушка, пока не создадим ProfileViewController в подфиче 2
        return UIViewController()
        
        // let viewController = ProfileViewController(viewModel: viewModel)
        // return viewController
    }
}
