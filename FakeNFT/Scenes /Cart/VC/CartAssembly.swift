//
//  CartAssembly.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 04.07.2026.
//

import UIKit

class CartAssembly {
    
    // MARK: - Public API
    
    /// Создает полностью настроенный CartViewController со всеми зависимостями и TabBarItem.
    /// - Returns: Настроенный экземпляр UINavigationController с CartViewController внутри.
    static func makeCartFlow() -> UINavigationController {
        // 1. Сборка сервисов (зависимости)
        let cartService = CartServiceImpl(networkClient: DefaultNetworkClient())
        let nftService = NFTServiceImpl()
        let paymentService = PaymentServiceImpl(
            client: DefaultNetworkClient(),
            baseURL: RequestConstants.baseURL
        )
        
        // 2. Сборка ViewModel
        let cartViewModel = CartViewModel(
            nftService: nftService,
            cartService: cartService
        )
        
        // 3. Сборка ViewController
        let cartController = CartViewController(
            viewModel: cartViewModel,
            paymentService: paymentService
        )
        
        // 4. Настройка TabBarItem (инкапсулирована внутри сборки)
        let cartTabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.cart", comment: ""),
            image: UIImage(resource: .basket), // Предполагается, что у UIImage есть такой initializer
            tag: 1
        )
        cartController.tabBarItem = cartTabBarItem
        
        // 5. Обертка в NavigationController
        return UINavigationController(rootViewController: cartController)
    }
}

