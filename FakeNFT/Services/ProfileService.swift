import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func loadProfile(completion: @escaping ProfileCompletion)
    func updateLikes(likeIds: [String], completion: @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadProfile(completion: @escaping ProfileCompletion) {
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self, onResponse: completion)
    }

    func updateLikes(likeIds: [String], completion: @escaping ProfileCompletion) {
        let request = ProfileLikesUpdateRequest(likeIds: likeIds)
        networkClient.send(request: request, type: Profile.self, onResponse: completion)
    }
}
