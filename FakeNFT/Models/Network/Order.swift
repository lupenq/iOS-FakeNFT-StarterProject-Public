import Foundation

struct Order: Decodable {
    let id: String
    let nfts: [String]
}

extension Order {
    /// Нормализованный список id NFT.
    /// Мок-сервер может возвращать значения, склеенные через запятую (например `["1,2,3"]`).
    var nftIds: [String] {
        nfts.normalizedIds
    }
}
