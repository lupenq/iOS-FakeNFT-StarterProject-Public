//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 19.06.2026.
//

import UIKit

final class CartViewModel {
    
    // MARK: - Output bindings
    
    var onItemsUpdated: (() -> Void)?
    var onTotalUpdated: ((String, String) -> Void)?
    var onLoadError: ((Error) -> Void)?
    
    // MARK: - Public Properties
    
    var itemsAmount: Int { items.count }
    
    // MARK: - Private Properties
    
    //private(set) var items = MockData.items
    private(set) var items: [NFTUIItem] = []
    private let nftService: NFTService
    private let cartService: CartService
    
    init(nftService: NFTService, cartService: CartService) {
        self.nftService = nftService
        self.cartService = cartService
    }
    
    // MARK: - Public Methods
    
    func loadCart() {
        
        cartService.fetchCart { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let order):
                let ids = order.nfts
                self.nftService.fetchNFTs(with: ids) { result in
                    switch result {
                    case .success(let nfts):
                        self.items = nfts.map { nft in
                            NFTUIItem(
                                id: nft.id,
                                image: nil,
                                imageUrl: nft.imageUrl,
                                title: nft.name,
                                rating: nft.rating ?? 0,
                                price: nft.price
                            )
                        }
                        self.notifyUpdates()
                    case .failure(let error):
                        self.onLoadError?(error)
                    }
                }
                
            case .failure(let error):
                self.onLoadError?(error)
            }
        }
    }
    
    
    func item(at index: Int) -> NFTUIItem { items[index] }
    
    func removeItem(at index: Int) {
        guard items.indices.contains(index) else { return }
        items.remove(at: index)
        notifyUpdates()
    }
    
    func updateTotal() {
        let countText = "\(items.count) NFT"
        let sum = items.reduce(0) { $0 + $1.price }
        let totalText = String(format: "%.2f ETH", sum).replacingOccurrences(of: ".", with: ",")
        
        onTotalUpdated?(countText, totalText)
    }
    
    func sortByPrice() {
        items.sort { $0.price < $1.price }
        notifyUpdates()
    }
    
    func sortByRating() {
        items.sort { $0.rating > $1.rating }
        notifyUpdates()
    }
    
    func sortByTitle() {
        items.sort { $0.title < $1.title }
        notifyUpdates()
    }
    
    func removeAllItems() {
        items.removeAll()
        notifyUpdates()
    }
    
    // MARK: - Private Methods
    
    private func notifyUpdates() {
        onItemsUpdated?()
        updateTotal()
    }
    
}
