//
//  FavouritesViewModel.swift
//  FakeNFT
//
//  Created by Данил Третьяченко on 28.06.2026.
//

import Foundation

final class FavouritesViewModel {
    
    // MARK: - Properties
    private let nftService: NftService
    private let profileService: ProfileServiceProtocol
    private var likedIds: [String]
    
    var onChange: (() -> Void)?
    
    private(set) var favoriteNfts: [Nft] = [] {
        didSet {
            onChange?()
        }
    }
    
    private(set) var isLoading: Bool = false {
        didSet {
            onChange?()
        }
    }
    
    private(set) var error: Error? {
        didSet {
            onChange?()
        }
    }
    
    // MARK: - Initialization
    init(likedIds: [String], nftService: NftService, profileService: ProfileServiceProtocol = ProfileService()) {
            self.likedIds = likedIds
            self.nftService = nftService
            self.profileService = profileService
        }
    
    // MARK: - Public Methods
    func loadFavorites() {
        guard !likedIds.isEmpty else {
            self.favoriteNfts = []
            return
        }
        
        isLoading = true
        let group = DispatchGroup()
        var loadedNfts: [Nft] = []
        var fetchError: Error?
        
        for id in likedIds {
            group.enter()
            nftService.loadNft(id: id) { result in
                switch result {
                case .success(let nft):
                    loadedNfts.append(nft)
                case .failure(let error):
                    fetchError = error
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            if let error = fetchError {
                self.error = error
            } else {
                self.favoriteNfts = loadedNfts
            }
        }
    }
    
    /// Метод для удаления из избранного прямо на экране коллекции
    func removeFormFavorites(nftId: String) {
        // Убираем ID из локального списка
        likedIds.removeAll { $0 == nftId }
        favoriteNfts.removeAll { $0.id == nftId }
        
        // Отправляем обновление на сервер, чтобы сохранить изменения
        // Для этого нужно будет перезаписать массив likes в профиле (сделаем в UI слое)
    }
}
