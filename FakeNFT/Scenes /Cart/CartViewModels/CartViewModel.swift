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
    
    // MARK: - Private Properties
    
    private(set) var items = MockData.items
    
    // MARK: - Public Methods
    
    func numberOfItems() -> Int { items.count }
    func item(at index: Int) -> NFTItem { items[index] }
    
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
    
    // MARK: - Private Methods
    
    private func notifyUpdates() {
        onItemsUpdated?()
        updateTotal()
    }
    
}
