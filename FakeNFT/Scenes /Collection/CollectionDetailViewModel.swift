import Foundation

enum CollectionDetailState {
    case initial
    case loading
    case data
    case failed(Error)
}

protocol CollectionDetailViewModelProtocol: AnyObject {
    var onStateChange: ((CollectionDetailState) -> Void)? { get set }
    var state: CollectionDetailState { get }
    var collection: NftCollection? { get }
    var numberOfNfts: Int { get }

    func viewDidLoad()
    func reload()
    func cellModel(at index: Int) -> NftCellModel
    func nftId(at index: Int) -> String
}

final class CollectionDetailViewModel: CollectionDetailViewModelProtocol {

    // MARK: - Bindings

    var onStateChange: ((CollectionDetailState) -> Void)?

    private(set) var state: CollectionDetailState = .initial {
        didSet { onStateChange?(state) }
    }

    // MARK: - Properties

    private let collectionId: String
    private let service: CollectionService
    private(set) var collection: NftCollection?
    private var nfts: [Nft] = []

    var numberOfNfts: Int { nfts.count }

    // MARK: - Init

    init(collectionId: String, service: CollectionService) {
        self.collectionId = collectionId
        self.service = service
    }

    // MARK: - Public

    func viewDidLoad() {
        load()
    }

    func reload() {
        load()
    }

    func cellModel(at index: Int) -> NftCellModel {
        NftCellModel(nft: nfts[index])
    }

    func nftId(at index: Int) -> String {
        nfts[index].id
    }

    // MARK: - Private

    private func load() {
        state = .loading
        service.loadCollection(id: collectionId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let collection):
                self.collection = collection
                self.loadNfts(ids: collection.nfts)
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }

    private func loadNfts(ids: [String]) {
        service.loadNfts(ids: ids) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let nfts):
                self.nfts = nfts
                self.state = .data
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
}
