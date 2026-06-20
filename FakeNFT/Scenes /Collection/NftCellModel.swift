import Foundation

struct NftCellModel {
    let id: String
    let name: String
    let imageURL: URL?
    let rating: Int
    let price: Float
}

extension NftCellModel {
    init(nft: Nft) {
        self.id = nft.id
        self.name = nft.name
        self.imageURL = nft.images.first
        self.rating = nft.rating
        self.price = nft.price
    }
}
