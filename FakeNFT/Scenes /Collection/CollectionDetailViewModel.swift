import Foundation

enum CollectionDetailState {
    case initial
    case loading
    case data
    case failed(Error)
}

enum CollectionDetailActionError: Error {
    case likesUnavailable
    case cartUnavailable
}

protocol CollectionDetailViewModelProtocol: AnyObject {
    var onStateChange: ((CollectionDetailState) -> Void)? { get set }
    var onNftChange: ((Int) -> Void)? { get set }
    var onProcessingChange: ((Bool) -> Void)? { get set }
    var onActionError: ((Error) -> Void)? { get set }

    var state: CollectionDetailState { get }
    var headerModel: CollectionHeaderModel? { get }
    var authorWebsite: URL? { get }
    var numberOfNfts: Int { get }

    func viewDidLoad()
    func reload()
    func cellModel(at index: Int) -> NftCellModel
    func isLiked(at index: Int) -> Bool
    func isInCart(at index: Int) -> Bool
    func nftId(at index: Int) -> String
    func toggleLike(at index: Int)
    func toggleCart(at index: Int)
}

final class CollectionDetailViewModel: CollectionDetailViewModelProtocol {

    // MARK: - Bindings

    var onStateChange: ((CollectionDetailState) -> Void)?
    var onNftChange: ((Int) -> Void)?
    var onProcessingChange: ((Bool) -> Void)?
    var onActionError: ((Error) -> Void)?

    private(set) var state: CollectionDetailState = .initial {
        didSet { onStateChange?(state) }
    }

    // MARK: - Properties

    private let collectionId: String
    private let collectionService: CollectionService
    private let orderService: OrderService
    private let profileService: ProfileService
    private let userService: UserService

    private(set) var collection: NftCollection?
    private var nfts: [Nft] = []
    private var author: User?

    private var likedIds: Set<String> = []
    private var cartIds: Set<String> = []
    private var likeInFlight: Set<String> = []
    private var cartInFlight: Set<String> = []

    private var likesLoaded = false
    private var cartLoaded = false

    var numberOfNfts: Int { nfts.count }

    var authorWebsite: URL? {
        author?.website ?? collection?.website
    }

    var headerModel: CollectionHeaderModel? {
        guard let collection else { return nil }
        let authorName = author?.name ?? collection.author
        return CollectionHeaderModel(
            coverURL: collection.cover,
            title: collection.name,
            authorName: authorName,
            description: collection.description
        )
    }

    // MARK: - Init

    init(
        collectionId: String,
        collectionService: CollectionService,
        orderService: OrderService,
        profileService: ProfileService,
        userService: UserService
    ) {
        self.collectionId = collectionId
        self.collectionService = collectionService
        self.orderService = orderService
        self.profileService = profileService
        self.userService = userService
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

    func isLiked(at index: Int) -> Bool {
        likedIds.contains(nfts[index].id)
    }

    func isInCart(at index: Int) -> Bool {
        cartIds.contains(nfts[index].id)
    }

    func nftId(at index: Int) -> String {
        nfts[index].id
    }

    func toggleLike(at index: Int) {
        guard nfts.indices.contains(index) else { return }
        guard likesLoaded else {
            onActionError?(CollectionDetailActionError.likesUnavailable)
            return
        }
        let id = nfts[index].id
        guard !likeInFlight.contains(id) else { return }
        likeInFlight.insert(id)

        let updated = likedIds.symmetricDifference([id])
        onProcessingChange?(true)
        profileService.updateLikes(likeIds: Array(updated)) { [weak self] result in
            guard let self else { return }
            self.likeInFlight.remove(id)
            self.onProcessingChange?(false)
            switch result {
            case .success(let profile):
                self.likedIds = Set(profile.likedIds)
                self.onNftChange?(index)
            case .failure(let error):
                self.onActionError?(error)
            }
        }
    }

    func toggleCart(at index: Int) {
        guard nfts.indices.contains(index) else { return }
        guard cartLoaded else {
            onActionError?(CollectionDetailActionError.cartUnavailable)
            return
        }
        let id = nfts[index].id
        guard !cartInFlight.contains(id) else { return }
        cartInFlight.insert(id)

        let updated = cartIds.symmetricDifference([id])
        onProcessingChange?(true)
        orderService.updateOrder(nftIds: Array(updated)) { [weak self] result in
            guard let self else { return }
            self.cartInFlight.remove(id)
            self.onProcessingChange?(false)
            switch result {
            case .success(let order):
                self.cartIds = Set(order.nftIds)
                self.onNftChange?(index)
            case .failure(let error):
                self.onActionError?(error)
            }
        }
    }

    // MARK: - Private

    private func load() {
        state = .loading
        collectionService.loadCollection(id: collectionId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let collection):
                self.collection = collection
                self.loadDetails(for: collection)
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }

    private func loadDetails(for collection: NftCollection) {
        let group = DispatchGroup()
        var nftsError: Error?

        group.enter()
        collectionService.loadNfts(ids: collection.nfts) { [weak self] result in
            switch result {
            case .success(let nfts):
                self?.nfts = nfts
            case .failure(let error):
                nftsError = error
            }
            group.leave()
        }

        cartLoaded = false
        likesLoaded = false

        group.enter()
        orderService.loadOrder { [weak self] result in
            if case .success(let order) = result {
                self?.cartIds = Set(order.nftIds)
                self?.cartLoaded = true
            }
            group.leave()
        }

        group.enter()
        profileService.loadProfile { [weak self] result in
            if case .success(let profile) = result {
                self?.likedIds = Set(profile.likedIds)
                self?.likesLoaded = true
            }
            group.leave()
        }

        group.enter()
        userService.loadUser(id: collection.author) { [weak self] result in
            if case .success(let user) = result {
                self?.author = user
            }
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            if let nftsError {
                self.state = .failed(nftsError)
            } else {
                self.state = .data
            }
        }
    }
}
