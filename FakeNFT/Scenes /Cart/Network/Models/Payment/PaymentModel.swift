//
//  PaymentModel.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 03.07.2026.
//

import Foundation

struct Currency: Decodable {
    let title: String
    let name: String
    let image: String
    let id: String
}

struct CreateOrderResponse: Decodable {
    let nfts: [String]
    let id: String
}

struct PayResponse: Decodable {
    let success: Bool
    let orderId: String
    let id: String
}

struct EmptyResponse: Decodable {}

struct EmptyDto: Dto {
    func asDictionary() -> [String: String] { [:] }
}

struct PaymentMethod {
    let id: String
    let title: String
    let name: String
    let image: String
}

struct GetOrdersRequest: NetworkRequest {
    let orderId: String
    var httpMethod: HttpMethod { .get }
    var dto: Dto? { EmptyDto() }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)")
    }
}

struct PutOrdersRequest: NetworkRequest {
    var httpMethod: HttpMethod { .put }
    var dto: Dto? { ChangeOrderDto(nfts: orders) }
    
    var orders: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

struct OrderRequest: NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Dto? { EmptyDto() }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var nfts: [String]?
}

struct CurrenciesRequest: NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Dto? { EmptyDto() }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}

struct PayRequest: NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Dto? { EmptyDto() }
    
    let currencyId: String
    let orderId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)/payment/\(currencyId)")
    }
    
    var nfts: [String]?
}

struct ChangeOrderRequest: NetworkRequest {
    let orderId: String
    let nfts: [String]
    
    var httpMethod: HttpMethod { .put }
    var dto: Dto? { ChangeOrderDto(nfts: nfts) }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)")
    }
}

struct ChangeOrderDto: Dto {
    let nfts: [String]
    
    func asDictionary() -> [String : String] {
        ["nfts": nfts.joined(separator: ",")]
    }
}
