import UIKit

final class CollectionDetailAssembly {

    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func makeViewModel(with input: CollectionDetailInput) -> CollectionDetailViewModelProtocol {
        CollectionDetailViewModel(
            collectionId: input.collectionId,
            collectionService: servicesAssembly.collectionService,
            orderService: servicesAssembly.orderService,
            profileService: servicesAssembly.profileService,
            userService: servicesAssembly.userService
        )
    }

    func build(with input: CollectionDetailInput) -> UIViewController {
        CollectionDetailViewController(
            viewModel: makeViewModel(with: input),
            servicesAssembly: servicesAssembly
        )
    }
}
