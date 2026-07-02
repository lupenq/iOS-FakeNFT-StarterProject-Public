import Foundation

typealias UserCompletion = (Result<User, Error>) -> Void

protocol UserService {
    func loadUser(id: String, completion: @escaping UserCompletion)
}

final class UserServiceImpl: UserService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadUser(id: String, completion: @escaping UserCompletion) {
        let request = UserByIdRequest(id: id)
        networkClient.send(request: request, type: User.self, onResponse: completion)
    }
}
