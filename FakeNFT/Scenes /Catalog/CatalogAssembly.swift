import UIKit

final class CatalogAssembly {

    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func makeViewModel() -> CatalogViewModelProtocol {
        CatalogViewModel(service: servicesAssembly.collectionService)
    }

    func build() -> UIViewController {
        CatalogViewController(
            viewModel: makeViewModel(),
            servicesAssembly: servicesAssembly
        )
    }
}
