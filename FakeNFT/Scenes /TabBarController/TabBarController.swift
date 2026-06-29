import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. Настройка первой вкладки (Каталог)
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem

        // 2. Настройка новой вкладки (Профиль) через наш Assembly
        let profileController = ProfileAssembly.assemble()

        // 3. Добавляем оба контроллера в нижнее меню
        viewControllers = [catalogController, profileController]

        view.backgroundColor = .systemBackground
    }
}
