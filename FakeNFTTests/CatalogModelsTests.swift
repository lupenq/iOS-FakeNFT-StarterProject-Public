import XCTest
@testable import FakeNFT

final class CatalogModelsTests: XCTestCase {

    func testNormalizedIdsSplitsCommaJoinedValues() {
        let raw = ["1,2", "3", "", " 4 "]
        XCTAssertEqual(raw.normalizedIds, ["1", "2", "3", "4"])
    }

    func testOrderNftIdsAreNormalized() {
        let order = Order(id: "1", nfts: ["93,94,95"])
        XCTAssertEqual(order.nftIds, ["93", "94", "95"])
    }

    func testProfileLikedIdsAreNormalized() {
        let profile = Profile(
            id: "1",
            name: "n",
            avatar: nil,
            description: nil,
            website: nil,
            nfts: [],
            likes: ["1,3,5"]
        )
        XCTAssertEqual(profile.likedIds, ["1", "3", "5"])
    }

    func testPriceTextDropsTrailingZeros() {
        let model = NftCellModel(
            id: "1",
            name: "Archie",
            imageURL: nil,
            rating: 2,
            price: 1
        )
        XCTAssertEqual(model.priceText, "1 ETH")
    }

    func testPriceTextHasEthSuffixForFractionalValue() {
        let model = NftCellModel(
            id: "1",
            name: "Archie",
            imageURL: nil,
            rating: 2,
            price: 1.78
        )
        XCTAssertTrue(model.priceText.hasSuffix(" ETH"))
        XCTAssertTrue(model.priceText.contains("1"))
    }
}
