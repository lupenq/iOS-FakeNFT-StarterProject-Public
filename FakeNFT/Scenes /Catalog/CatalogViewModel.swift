import Foundation

enum CatalogState {
    case initial
    case loading
    case data
    case failed(Error)
}

protocol CatalogViewModelProtocol: AnyObject {
    var onStateChange: ((CatalogState) -> Void)? { get set }
    var state: CatalogState { get }
    var sortOption: CatalogSortOption { get }
    var numberOfCollections: Int { get }

    func viewDidLoad()
    func reload()
    func cellModel(at index: Int) -> CatalogCellModel
    func collectionId(at index: Int) -> String
    func setSortOption(_ option: CatalogSortOption)
}

final class CatalogViewModel: CatalogViewModelProtocol {

    // MARK: - Bindings

    var onStateChange: ((CatalogState) -> Void)?

    private(set) var state: CatalogState = .initial {
        didSet { onStateChange?(state) }
    }

    // MARK: - Properties

    private let service: CollectionService
    private let sortStore: CatalogSortStore
    private var collections: [NftCollection] = []

    var sortOption: CatalogSortOption { sortStore.option }

    var numberOfCollections: Int { collections.count }

    // MARK: - Init

    init(service: CollectionService, sortStore: CatalogSortStore = CatalogSortStore()) {
        self.service = service
        self.sortStore = sortStore
    }

    // MARK: - Public

    func viewDidLoad() {
        loadCollections()
    }

    func reload() {
        loadCollections()
    }

    func cellModel(at index: Int) -> CatalogCellModel {
        CatalogCellModel(collection: collections[index])
    }

    func collectionId(at index: Int) -> String {
        collections[index].id
    }

    func setSortOption(_ option: CatalogSortOption) {
        sortStore.option = option
        applySort()
        state = .data
    }

    // MARK: - Private

    private func loadCollections() {
        state = .loading
        service.loadCollections { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let collections):
                self.collections = collections
                self.applySort()
                self.state = .data
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }

    private func applySort() {
        switch sortStore.option {
        case .name:
            collections.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .nftCount:
            collections.sort { $0.nfts.count > $1.nfts.count }
        }
    }
}
