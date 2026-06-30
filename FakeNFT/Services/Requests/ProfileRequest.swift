import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var dto: Dto?
}

struct ProfileLikesUpdateRequest: NetworkRequest {
    let likeIds: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod: HttpMethod { .put }

    var dto: Dto? {
        LikesDto(ids: likeIds)
    }
}

private struct LikesDto: Dto {
    let ids: [String]

    func asDictionary() -> [String: String] {
        guard !ids.isEmpty else { return [:] }
        return ["likes": ids.joined(separator: ",")]
    }
}
