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

        // 3. Кнопка корзины — состояние переключается (ждём смену accessibilityValue, а не sleep).
        let cartButton = app.collectionViews.buttons["nft.cartButton"].firstMatch
        XCTAssertTrue(cartButton.waitForExistence(timeout: networkTimeout))
        let cartValueBefore = cartButton.value as? String
        cartButton.tap()
        waitForValueChange(of: cartButton, from: cartValueBefore, message: "Состояние корзины не изменилось")
        attach(app, name: "03-after-cart")

        // 4. Кнопка избранного — лайк/дизлайк (ждём смену состояния).
        let likeButton = app.collectionViews.buttons["nft.likeButton"].firstMatch
        XCTAssertTrue(likeButton.waitForExistence(timeout: networkTimeout))
        let likeValueBefore = likeButton.value as? String
        likeButton.tap()
        waitForValueChange(of: likeButton, from: likeValueBefore, message: "Состояние избранного не изменилось")
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

        // 6. Тап по NFT открывает экран деталей (модально поверх — кнопки коллекции пропадают).
        let nft = app.collectionViews.cells.element(boundBy: 0)
        XCTAssertTrue(nft.waitForExistence(timeout: networkTimeout))
        nft.tap()
        XCTAssertTrue(
            cartButton.waitForNonExistence(timeout: networkTimeout),
            "Экран деталей NFT не открылся поверх коллекции"
        )
        attach(app, name: "06-nft-detail")
    }

    /// Ждёт, пока `accessibilityValue` элемента станет отличным от исходного (замена flaky `sleep`).
    private func waitForValueChange(
        of element: XCUIElement,
        from oldValue: String?,
        message: String
    ) {
        let predicate = NSPredicate(format: "value != %@", oldValue ?? "")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        XCTAssertEqual(
            XCTWaiter().wait(for: [expectation], timeout: networkTimeout),
            .completed,
            message
        )
    }

    private func attach(_ app: XCUIApplication, name: String) {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
