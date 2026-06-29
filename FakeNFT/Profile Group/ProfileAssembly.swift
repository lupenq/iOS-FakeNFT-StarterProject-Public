import UIKit

final class ProfileAssembly {
    static func assemble() -> UIViewController {
        let networkClient = DefaultNetworkClient()
        let profileService = ProfileService(networkClient: networkClient)
        
        let viewModel = ProfileViewModel(profileService: profileService)
        let viewController = ProfileViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle.fill")
        )
        
        return navigationController
    }
}
