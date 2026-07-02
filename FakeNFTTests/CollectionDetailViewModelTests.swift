import XCTest
@testable import FakeNFT

final class CollectionDetailViewModelTests: XCTestCase {

    // MARK: - Helpers

    private func makeNft(id: String, price: Float = 1, rating: Int = 3) -> Nft {
        Nft(
            id: id,
            name: "Nft \(id)",
            images: [URL(fileURLWithPath: "/tmp/\(id).png")],
            rating: rating,
            price: price,
            description: "desc",
            author: "1",
            website: URL(fileURLWithPath: "/tmp"),
            createdAt: "2023-04-20T02:22:27Z"
        )
    }

    private func makeCollection(nftIds: [String]) -> NftCollection {
        NftCollection(
            id: "c1",
            name: "Peach",
            cover: URL(fileURLWithPath: "/tmp/cover.png"),
            nfts: nftIds,
            description: "Персиковый",
            author: "42",
            website: URL(fileURLWithPath: "/tmp"),
            createdAt: "2023-04-20T02:22:27Z"
        )
    }

    private func makeViewModel(
        nfts: [Nft],
        order: StubOrderService = StubOrderService(),
        profile: StubProfileService = StubProfileService(),
        user: StubUserService = StubUserService()
    ) -> CollectionDetailViewModel {
        let collection = makeCollection(nftIds: nfts.map { $0.id })
        let collectionService = StubCollectionService(collection: collection, nfts: nfts)
        return CollectionDetailViewModel(
            collectionId: "c1",
            collectionService: collectionService,
            orderService: order,
            profileService: profile,
            userService: user
        )
    }

    private func loadToData(_ viewModel: CollectionDetailViewModel) {
        let exp = expectation(description: "data")
        viewModel.onStateChange = { state in
            if case .data = state { exp.fulfill() }
        }
        viewModel.viewDidLoad()
        wait(for: [exp], timeout: 1)
    }

    // MARK: - Loading

    func testViewDidLoadLoadsNftsAndAuthor() {
        let user = StubUserService()
        user.user = User(id: "42", name: "John Doe", website: URL(fileURLWithPath: "/tmp"))
        let viewModel = makeViewModel(nfts: [makeNft(id: "a"), makeNft(id: "b")], user: user)

        loadToData(viewModel)

        XCTAssertEqual(viewModel.numberOfNfts, 2)
        XCTAssertEqual(viewModel.headerModel?.title, "Peach")
        XCTAssertEqual(viewModel.headerModel?.authorName, "John Doe")
    }

    // MARK: - Cart

    func testToggleCartAddsThenRemoves() {
        let order = StubOrderService()
        let viewModel = makeViewModel(nfts: [makeNft(id: "a")], order: order)
        loadToData(viewModel)

        XCTAssertFalse(viewModel.isInCart(at: 0))

        viewModel.toggleCart(at: 0)
        XCTAssertTrue(viewModel.isInCart(at: 0), "После добавления NFT должен быть в корзине")

        viewModel.toggleCart(at: 0)
        XCTAssertFalse(viewModel.isInCart(at: 0), "После повторного нажатия NFT удаляется из корзины")
    }

    // MARK: - Likes

    func testToggleLikeAddsThenRemoves() {
        let profile = StubProfileService()
        let viewModel = makeViewModel(nfts: [makeNft(id: "a")], profile: profile)
        loadToData(viewModel)

        XCTAssertFalse(viewModel.isLiked(at: 0))

        viewModel.toggleLike(at: 0)
        XCTAssertTrue(viewModel.isLiked(at: 0))

        viewModel.toggleLike(at: 0)
        XCTAssertFalse(viewModel.isLiked(at: 0))
    }

    // MARK: - In-flight guard

    func testToggleCartIgnoresRepeatedTapWhileRequestInFlight() {
        let order = StubOrderService()
        order.holdCompletion = true
        let viewModel = makeViewModel(nfts: [makeNft(id: "a")], order: order)
        loadToData(viewModel)

        viewModel.toggleCart(at: 0)
        viewModel.toggleCart(at: 0)

        XCTAssertEqual(order.updateCallCount, 1, "Повторное нажатие во время запроса должно игнорироваться")
    }

    // MARK: - Action error

    // MARK: - Action availability

    func testActionsEnabledWhenLikesAndCartLoaded() {
        let viewModel = makeViewModel(nfts: [makeNft(id: "a")])
        loadToData(viewModel)

        XCTAssertTrue(viewModel.canToggleLikes)
        XCTAssertTrue(viewModel.canToggleCart)
    }

    func testActionsDisabledWhenLikesAndCartFailedToLoad() {
        let order = StubOrderService()
        order.failLoad = true
        let profile = StubProfileService()
        profile.failLoad = true
        let viewModel = makeViewModel(nfts: [makeNft(id: "a")], order: order, profile: profile)
        loadToData(viewModel)

        XCTAssertFalse(viewModel.canToggleLikes, "Кнопка лайка должна быть отключена при сбое загрузки профиля")
        XCTAssertFalse(viewModel.canToggleCart, "Кнопка корзины должна быть отключена при сбое загрузки заказа")
    }

    // MARK: - Guard against overwriting unknown state

    func testToggleCartBlockedAndReportsErrorWhenCartFailedToLoad() {
        let order = StubOrderService()
        order.failLoad = true
        let viewModel = makeViewModel(nfts: [makeNft(id: "a")], order: order)
        loadToData(viewModel)

        var reported = false
        viewModel.onActionError = { _ in reported = true }
        viewModel.toggleCart(at: 0)

        XCTAssertTrue(reported, "Должна сообщаться ошибка, если корзина не загружена")
        XCTAssertEqual(order.updateCallCount, 0, "Нельзя слать полный набор от неизвестной базы — иначе затрём заказ")
        XCTAssertFalse(viewModel.isInCart(at: 0))
    }

    func testToggleLikeBlockedWhenProfileFailedToLoad() {
        let profile = StubProfileService()
        profile.failLoad = true
        let viewModel = makeViewModel(nfts: [makeNft(id: "a")], profile: profile)
        loadToData(viewModel)

        viewModel.toggleLike(at: 0)

        XCTAssertEqual(profile.updateCallCount, 0, "Нельзя перезаписывать лайки от неизвестной базы")
    }

    func testToggleCartReportsErrorOnFailure() {
        let order = StubOrderService()
        order.shouldFail = true
        let viewModel = makeViewModel(nfts: [makeNft(id: "a")], order: order)
        loadToData(viewModel)

        var reported = false
        viewModel.onActionError = { _ in reported = true }
        viewModel.toggleCart(at: 0)

        XCTAssertTrue(reported)
        XCTAssertFalse(viewModel.isInCart(at: 0))
    }
}
