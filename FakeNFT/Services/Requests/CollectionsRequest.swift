import Foundation

struct CollectionsRequest: NetworkRequest {
    let page: Int?
    let size: Int?
    let sortBy: String?

    init(page: Int? = nil, size: Int? = nil, sortBy: String? = nil) {
        self.page = page
        self.size = size
        self.sortBy = sortBy
    }

    var endpoint: URL? {
        var components = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/collections")
        var queryItems: [URLQueryItem] = []
        if let page { queryItems.append(URLQueryItem(name: "page", value: "\(page)")) }
        if let size { queryItems.append(URLQueryItem(name: "size", value: "\(size)")) }
        if let sortBy { queryItems.append(URLQueryItem(name: "sortBy", value: sortBy)) }
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        return components?.url
    }

    var dto: Dto?
}
