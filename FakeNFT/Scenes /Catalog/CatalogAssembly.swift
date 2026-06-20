import Foundation

final class CatalogAssembly {

    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func makeViewModel() -> CatalogViewModelProtocol {
        CatalogViewModel(service: servicesAssembly.collectionService)
    }
}
