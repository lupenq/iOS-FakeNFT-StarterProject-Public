import Foundation

struct Profile: Decodable {
    let id: String
    let name: String
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]
    let likes: [String]
}

extension Profile {
    /// Нормализованный список id лайкнутых NFT (мок-сервер может склеивать значения через запятую).
    var likedIds: [String] {
        likes.normalizedIds
    }
}
