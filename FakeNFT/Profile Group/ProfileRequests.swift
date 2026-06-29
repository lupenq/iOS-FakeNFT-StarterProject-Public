//
//  ProfileRequests.swift
//  FakeNFT
//
//  Created by Данил Третьяченко on 28.06.2026.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        return URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}

struct ProfileUpdateRequest: NetworkRequest {
    let updateDto: ProfileUpdateDto
    
    var endpoint: URL? {
        return URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod { .put }
    var dto: Dto? { updateDto }
}
