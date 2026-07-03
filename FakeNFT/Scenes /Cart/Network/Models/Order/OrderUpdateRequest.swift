//
//  OrderUpdateRequest.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 01.07.2026.
//

import Foundation

struct OrderUpdateRequest: NetworkRequest {
    let endpoint: URL?
    let httpMethod: HttpMethod = .put
    let dto: Dto?
    
    init(orderId: String, nfts: [String]) {
        self.endpoint = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/orders/\(orderId)")
        self.dto = OrderUpdateDto(nfts: nfts)
    }
    
}
