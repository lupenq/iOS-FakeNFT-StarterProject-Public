//
//  NftsListRequest.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 02.07.2026.
//

import Foundation

struct NftListRequest: NetworkRequest {
    let endpoint: URL?
    let httpMethod: HttpMethod = .get
    let dto: Dto? = nil
    
    init(ids: [String]) {
        let idsQuery = ids.joined(separator: ",")
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/nft?ids=\(idsQuery)") else {
            fatalError("Invalid NFT list URL") // или выбрасывать ошибку, если нужно
        }
        self.endpoint = url
    }
}
