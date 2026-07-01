//
//  OrderFetchRequest.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 01.07.2026.
//

import Foundation

struct OrderFetchRequest: NetworkRequest {
    let endpoint: URL?
    //let httpMethod: HttpMethod = .get
    let dto: Dto? = nil
        
    init(orderId: String) { 
        self.endpoint = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/orders/\(orderId)")
    }
    
    
}
