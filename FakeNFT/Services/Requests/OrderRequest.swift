import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var dto: Dto?
}

struct OrderUpdateRequest: NetworkRequest {
    let nftIds: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod { .put }

    var dto: Dto? {
        NftIdsDto(ids: nftIds)
    }
}

private struct NftIdsDto: Dto {
    let ids: [String]

    func asDictionary() -> [String: String] {
        guard !ids.isEmpty else { return [:] }
        return ["nfts": ids.joined(separator: ",")]
    }
}
