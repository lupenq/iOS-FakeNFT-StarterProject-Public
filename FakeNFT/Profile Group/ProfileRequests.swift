//
//  ProfileRequests.swift
//  FakeNFT
//
//  Created by Данил Третьяченко on 28.06.2026.
//

import Foundation

// MARK: - GET Request
struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        return URL(string: "https://d5d-g913aba5alclgert.api.cloudfunctions.net/yandex-practicum/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    var dto: Dto? {
        return nil
    }
}

// MARK: - PUT Request
struct ProfileUpdateRequest: NetworkRequest {
    let updateDto: ProfileUpdateDto
    
    var endpoint: URL? {
        return URL(string: "https://d5d-g913aba5alclgert.api.cloudfunctions.net/yandex-practicum/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod {
        return .put
    }
    
    var dto: Dto? {
        return updateDto
    }
}
