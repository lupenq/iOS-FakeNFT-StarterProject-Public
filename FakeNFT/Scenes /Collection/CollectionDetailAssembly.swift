import UIKit

final class CollectionDetailAssembly {

    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func makeViewModel(with input: CollectionDetailInput) -> CollectionDetailViewModelProtocol {
        CollectionDetailViewModel(
            collectionId: input.collectionId,
            service: servicesAssembly.collectionService
        )
    }

    func build(with input: CollectionDetailInput) -> UIViewController {
        CollectionDetailViewController(viewModel: makeViewModel(with: input))
    }
}
