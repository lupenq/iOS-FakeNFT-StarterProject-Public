import Foundation

enum MyNftsSortType: String {
    case price
    case rating
    case name
}

final class MyNftsViewModel {
    
    // MARK: - Properties
    private let nftIds: [String]
    private let nftService: NftServiceImpl
    private let sortKey = "MyNftsSortTypeKey"
    
    private(set) var nfts: [Nft] = [] {
        didSet {
            onChange?()
        }
    }
    
    private(set) var isLoading: Bool = false {
        didSet {
            onLoadingStateChange?()
        }
    }
    
    // MARK: - Closures for Binding
    var onChange: (() -> Void)?
    var onLoadingStateChange: (() -> Void)?
    
    // MARK: - Initialization
    init(nftIds: [String], nftService: NftServiceImpl) {
        self.nftIds = nftIds
        self.nftService = nftService
    }
    
    // MARK: - Public Methods
    func loadNfts() {
        guard !nftIds.isEmpty else {
            self.nfts = []
            return
        }
        
        isLoading = true
        
        let dispatchGroup = DispatchGroup()
        var loadedNfts: [Nft] = []
        
        for id in nftIds {
            dispatchGroup.enter()
            nftService.loadNft(id: id) { result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let nft):
                    loadedNfts.append(nft)
                case .failure(let error):
                    print("❌ Ошибка загрузки NFT \(id): \(error.localizedDescription)")
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.isLoading = false
            self.nfts = loadedNfts
            self.applyCurrentSort()
        }
    }
    
    func changeSort(to type: MyNftsSortType) {
        UserDefaults.standard.set(type.rawValue, forKey: sortKey)
        applyCurrentSort()
    }
    
    // MARK: - Private Methods
    private func applyCurrentSort() {
        let savedSortRaw = UserDefaults.standard.string(forKey: sortKey) ?? MyNftsSortType.rating.rawValue
        let currentSort = MyNftsSortType(rawValue: savedSortRaw) ?? .rating
        
        switch currentSort {
        case .price:
            nfts.sort { $0.price < $1.price }
        case .rating:
            nfts.sort { $0.rating > $1.rating }
        case .name:
            nfts.sort { $0.name < $1.name }
        }
    }
}
