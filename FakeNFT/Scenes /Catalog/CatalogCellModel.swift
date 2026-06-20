import Foundation

struct CatalogCellModel {
    let id: String
    let title: String
    let coverURL: URL
    let nftCount: Int
}

extension CatalogCellModel {
    init(collection: NftCollection) {
        self.id = collection.id
        self.title = collection.name
        self.coverURL = collection.cover
        self.nftCount = collection.nfts.count
    }
}
