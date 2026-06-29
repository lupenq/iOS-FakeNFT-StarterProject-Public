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
    var onError: ((_ retryHandler: @escaping () -> Void) -> Void)?
    
    // MARK: - Public Properties
    
    
    
    // MARK: - Private Properties
    
    private(set) var items: [Currency] = MockCurrency.items
    private(set) var selectedIndex: IndexPath?
    
    // MARK: - Public Methods
    
    func selectItem(at indexPath: IndexPath) {
        selectedIndex = indexPath
    }
    
    func pay() {
        let success = Bool.random()
        if success {
            onSuccess?()
        } else {
            onError? { [weak self] in
                self?.pay()
            }
        }
    }
}
