//
//  CartServiceImpl.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 01.07.2026.
//

import Foundation

protocol CartService {
    func fetchCart(completion: @escaping (Result<OrderResponse, Error>) -> Void)
    func updateCart(nftIds: [String], completion: @escaping (Result<OrderResponse, Error>) -> Void)
}

final class CartServiceImpl: CartService {
  
    private let networkClient: NetworkClient
    private let orderId = "1"
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchCart(completion: @escaping (Result<OrderResponse, Error>) -> Void) {
        let request = OrderFetchRequest(orderId: orderId)
        networkClient.send(request: request, type: OrderResponse.self, completionQueue: .main, onResponse: completion)
    }
    
    func updateCart(nftIds: [String], completion: @escaping (Result<OrderResponse, Error>) -> Void) {
        let request = OrderUpdateRequest(orderId: orderId, nfts: nftIds)
        networkClient.send(request: request, type: OrderResponse.self, completionQueue: .main, onResponse: completion)
    }
    
}
