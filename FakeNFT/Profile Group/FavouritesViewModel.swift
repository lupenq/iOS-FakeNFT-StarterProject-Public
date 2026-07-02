//
//  FavouritesViewModel.swift
//  FakeNFT
//
//  Created by Данил Третьяченко on 28.06.2026.
//

import Foundation

final class FavouritesViewModel {
    
    // MARK: - Properties
    private var likedIds: [String]
    private let nftService: NftServiceImpl
    
    private(set) var favouritesNfts: [Nft] = [] {
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
    init(likedIds: [String], nftService: NftServiceImpl) {
        self.likedIds = likedIds
        self.nftService = nftService
    }
    
    // MARK: - Public Methods
    func loadFavourites() {
        guard !likedIds.isEmpty else {
            self.favouritesNfts = []
            return
        }
        
        isLoading = true
        let dispatchGroup = DispatchGroup()
        var loadedNfts: [Nft] = []
        
        for id in likedIds {
            dispatchGroup.enter()
            nftService.loadNft(id: id) { result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let nft):
                    loadedNfts.append(nft)
                case .failure(let error):
                    print("❌ Ошибка загрузки избранного NFT \(id): \(error.localizedDescription)")
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.isLoading = false
            
            self.favouritesNfts = self.likedIds.compactMap { id in
                loadedNfts.first(where: { $0.id == id })
            }
        }
    }
    
    func removeNftFromFavourites(at index: Int) {
        guard index < favouritesNfts.count else { return }
        let removedNft = favouritesNfts[index]
        
        
        likedIds.removeAll { $0 == removedNft.id }
        favouritesNfts.remove(at: index)
        
        print("💾 NFT \(removedNft.id) удален из лайков. Отправьте запрос обновления профиля.")
    }
}
