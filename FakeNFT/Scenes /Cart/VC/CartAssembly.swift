//
//  CartAssembly.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 04.07.2026.
//

import UIKit

class CartAssembly {
    
    // MARK: - Public API
    
    static func makeCartFlow() -> UINavigationController {
        let cartService = CartServiceImpl(networkClient: DefaultNetworkClient())
        let nftService = NFTServiceImpl()
        let paymentService = PaymentServiceImpl(
            client: DefaultNetworkClient(),
            baseURL: RequestConstants.baseURL
        )
        
        let cartViewModel = CartViewModel(
            nftService: nftService,
            cartService: cartService
        )
        
        let cartController = CartViewController(
            viewModel: cartViewModel,
            paymentService: paymentService
        )
        
        let cartTabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.cart", comment: ""),
            image: UIImage(resource: .basket),
            tag: 1
        )
        cartController.tabBarItem = cartTabBarItem
        
        return UINavigationController(rootViewController: cartController)
    }
}
