//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 23.06.2026.
//

import UIKit

final class PaymentViewModel {
    
    // MARK: - Output bindings
    
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onItemsLoaded: (() -> Void)?
    var onImageLoaded: ((IndexPath, UIImage?) -> Void)?
    
    // MARK: - Private Properties
    
    ///mockData
    //private(set) var items: [CurrencyMockData] = MockCurrency.items
    private(set) var items: [PaymentMethod] = []
    private(set) var images: [UIImage?] = []
    private(set) var selectedIndex: IndexPath?
    
    private let paymentService: PaymentService
    private let imageLoader: ImageLoader
    
    private let nftsIds: [String]
    private var orderId: String?
    
    // MARK: Initialisers
    
    init(paymentService: PaymentService, imageLoader: ImageLoader = DefaultImageLoader(), nftIds: [String]) {
        self.paymentService = paymentService
        self.imageLoader = imageLoader
        self.nftsIds = nftIds
    }
    
    // MARK: - Public Methods
    
    func loadCurrencies() {
        paymentService.fetchCurrencies { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let currencies):
                self.items = currencies.map { PaymentMethod(id: $0.id, title: $0.title, name: $0.name, image: $0.image) }
                self.images = Array(repeating: nil, count: self.items.count)
                for (index, item) in self.items.enumerated() {
                    if item.image.isEmpty { continue }
                    let indexPath = IndexPath(item: index, section: 0)
                    self.loadImage(for: indexPath, urlString: item.image)
                }
                self.onItemsLoaded?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    func selectItem(at indexPath: IndexPath) {
        selectedIndex = indexPath
    }
    
    func pay() {
        guard let index = selectedIndex else {
            return
        }
        
        let currency = items[index.item]
        createOrderIfNeeded(currency: currency)
    }
    
    
    // MARK: - Private Methods
    
    private func createOrderIfNeeded(currency: PaymentMethod) {
        if let orderId {
            pay(orderId: orderId, currencyId: currency.id)
            return
        }
        
        paymentService.createOrder(nfts: nftsIds, currency: currency.name) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.orderId = response.id
                self.pay(orderId: response.id, currencyId: currency.id)
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    private func pay(orderId: String, currencyId: String) {
        paymentService.pay(orderId: orderId, currencyId: currencyId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.onSuccess?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    private func loadImage(for indexPath: IndexPath, urlString: String) {
        imageLoader.loadImage(from: urlString) { [weak self] image in
            guard let self else { return }
            // Сохраняем картинку в массив
            guard indexPath.item < self.images.count else { return }
            self.images[indexPath.item] = image
            
            // Сообщаем ViewController/CollectionView, что нужно обновить ячейку
            self.onImageLoaded?(indexPath, image)
        }
    }
    
    /// Вспомогательный метод, чтобы ячейка могла запросить картинку по индексу
    func image(for indexPath: IndexPath) -> UIImage? {
        guard indexPath.item < images.count else { return nil }
        return images[indexPath.item]
    }
}
