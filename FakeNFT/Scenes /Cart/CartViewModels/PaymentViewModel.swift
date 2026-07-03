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
    
    // MARK: - Private Properties
    
    ///mockData
    //private(set) var items: [CurrencyMockData] = MockCurrency.items
    private(set) var items: [PaymentMethod] = []
    private(set) var selectedIndex: IndexPath?
    private let paymentService: PaymentService
    private let nftsIds: [String]
    private var orderId: String?
    
    // MARK: Initialisers
    
    init(paymentService: PaymentService, nftIds: [String]) {
        self.paymentService = paymentService
        self.nftsIds = nftIds
    }
    
    // MARK: - Public Methods
    
    func loadCurrencies() {
        paymentService.fetchCurrencies { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let currencies):
                self.items = currencies.map { PaymentMethod(id: $0.id, title: $0.title, name: $0.name, image: $0.image) }
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
}
