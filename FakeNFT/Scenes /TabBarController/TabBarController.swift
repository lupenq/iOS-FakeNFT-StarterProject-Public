import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(resource: .basket),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        
        let cartService = CartServiceImpl(networkClient: DefaultNetworkClient())
        let nftService = NFTServiceImpl()
        let cartViewModel = CartViewModel(nftService: nftService, cartService: cartService)
        let paymentService = PaymentServiceImpl(client: DefaultNetworkClient(), baseURL: RequestConstants.baseURL)
        
        let cartController = CartViewController(viewModel: cartViewModel, paymentService: paymentService)
        
        catalogController.tabBarItem = catalogTabBarItem
        cartController.tabBarItem = cartTabBarItem
        
        let cartNavigationController = UINavigationController(rootViewController: cartController)

        viewControllers = [catalogController, cartNavigationController]

        view.backgroundColor = .systemBackground
    }
}
