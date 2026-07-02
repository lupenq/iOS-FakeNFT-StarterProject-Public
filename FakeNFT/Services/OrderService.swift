import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void

protocol OrderService {
    func loadOrder(completion: @escaping OrderCompletion)
    func updateOrder(nftIds: [String], completion: @escaping OrderCompletion)
}

final class OrderServiceImpl: OrderService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadOrder(completion: @escaping OrderCompletion) {
        let request = OrderRequest()
        networkClient.send(request: request, type: Order.self, onResponse: completion)
    }

    func updateOrder(nftIds: [String], completion: @escaping OrderCompletion) {
        let request = OrderUpdateRequest(nftIds: nftIds)
        networkClient.send(request: request, type: Order.self, onResponse: completion)
    }
}
