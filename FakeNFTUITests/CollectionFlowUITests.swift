import XCTest

final class CollectionFlowUITests: XCTestCase {

    private let networkTimeout: TimeInterval = 90

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testCollectionFlow() throws {
        let app = XCUIApplication()
        app.launch()

        // 1. Каталог: дожидаемся загрузки и открываем первую коллекцию.
        let firstCollection = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(
            firstCollection.waitForExistence(timeout: networkTimeout),
            "Список коллекций не загрузился"
        )
        attach(app, name: "01-catalog")
        firstCollection.tap()

        // 2. Экран коллекции: сетка NFT.
        let firstNft = app.collectionViews.cells.element(boundBy: 0)
        XCTAssertTrue(
            firstNft.waitForExistence(timeout: networkTimeout),
            "Сетка NFT не загрузилась"
        )
        attach(app, name: "02-collection")

        // 3. Кнопка корзины — добавление/удаление.
        let cartButton = app.collectionViews.buttons["nft.cartButton"].firstMatch
        XCTAssertTrue(cartButton.waitForExistence(timeout: networkTimeout))
        cartButton.tap()
        sleep(3)
        attach(app, name: "03-after-cart")

        // 4. Кнопка избранного — лайк/дизлайк.
        let likeButton = app.collectionViews.buttons["nft.likeButton"].firstMatch
        XCTAssertTrue(likeButton.waitForExistence(timeout: networkTimeout))
        likeButton.tap()
        sleep(3)
        attach(app, name: "04-after-like")

        // 5. Ссылка на автора открывает WKWebView.
        let authorButton = app.buttons["collection.authorButton"].firstMatch
        if authorButton.waitForExistence(timeout: 5) {
            authorButton.tap()
            let webView = app.webViews.element(boundBy: 0)
            XCTAssertTrue(
                webView.waitForExistence(timeout: networkTimeout),
                "Сайт автора не открылся в WKWebView"
            )
            attach(app, name: "05-author-web")
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }

        // 6. Тап по NFT открывает экран деталей.
        let nft = app.collectionViews.cells.element(boundBy: 0)
        XCTAssertTrue(nft.waitForExistence(timeout: networkTimeout))
        nft.tap()
        sleep(3)
        attach(app, name: "06-nft-detail")
    }

    private func attach(_ app: XCUIApplication, name: String) {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
