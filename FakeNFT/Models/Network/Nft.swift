import Foundation

struct Nft: Decodable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let price: Float
    let description: String
    let author: String
    let website: URL
    let createdAt: String
}
