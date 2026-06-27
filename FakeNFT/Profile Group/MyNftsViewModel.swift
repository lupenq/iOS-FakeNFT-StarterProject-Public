//
//  MyNftsViewModel.swift
//  FakeNFT
//
//  Created by Данил Третьяченко on 28.06.2026.
//

import Foundation

// Перечисление для типов сортировки
enum MyNftsSortType: String {
    case price = "price"
    case rating = "rating"
    case name = "name"
}

final class MyNftsViewModel {
    
    // MARK: - Properties
    private let nftService: NftService // Используем готовый сервис из проекта
    private let nftIds: [String]
    private let userDefaultsKey = "MyNftsSortTypeKey"
    
    var onChange: (() -> Void)?
    
    private(set) var nfts: [Nft] = [] {
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
    init(nftIds: [String], nftService: NftService) {
        self.nftIds = nftIds
        self.nftService = nftService
    }
    
    // MARK: - Public Methods
    func loadMyNfts() {
        guard !nftIds.isEmpty else { return }
        isLoading = true
        
        let group = DispatchGroup()
        var loadedNfts: [Nft] = []
        var fetchError: Error?
        
        for id in nftIds {
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
                self.nfts = loadedNfts
                self.applyCurrentSort() // Автоматически сортируем при загрузке
            }
        }
    }
    
    func changeSort(to type: MyNftsSortType) {
        UserDefaults.standard.set(type.rawValue, forKey: userDefaultsKey)
        applyCurrentSort()
    }
    
    // MARK: - Private Methods
    private func applyCurrentSort() {
        let savedRawValue = UserDefaults.standard.string(forKey: userDefaultsKey) ?? MyNftsSortType.rating.rawValue
        let currentSort = MyNftsSortType(rawValue: savedRawValue) ?? .rating
        
        switch currentSort {
        case .price:
            nfts.sort { (lhs: Nft, rhs: Nft) -> Bool in
                return lhs.price < rhs.price
            }
        case .rating:
            nfts.sort { (lhs: Nft, rhs: Nft) -> Bool in
                return lhs.rating > rhs.rating
            }
        case .name:
            nfts.sort { (lhs: Nft, rhs: Nft) -> Bool in
                return lhs.name.localizedCompare(rhs.name) == .orderedAscending
            }
        }
    }
}
