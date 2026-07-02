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

    var priceText: String {
        let formatted = NftCellModel.priceFormatter.string(from: NSNumber(value: price)) ?? "\(price)"
        return "\(formatted) ETH"
    }

    private static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
