import Foundation
@testable import FakeNFT

enum TestError: Error { case stub }

final class StubCollectionService: CollectionService {
    private let collection: NftCollection
    private let nfts: [Nft]

    init(collection: NftCollection, nfts: [Nft]) {
        self.collection = collection
        self.nfts = nfts
    }

    func loadCollections(completion: @escaping CollectionsCompletion) {
        completion(.success([collection]))
    }

    func loadCollection(id: String, completion: @escaping CollectionCompletion) {
        completion(.success(collection))
    }

    func loadNfts(ids: [String], completion: @escaping NftsCompletion) {
        completion(.success(nfts))
    }
}

final class StubOrderService: OrderService {
    var holdCompletion = false
    var shouldFail = false
    var failLoad = false
    private(set) var updateCallCount = 0
    private var current: [String] = []

    func loadOrder(completion: @escaping OrderCompletion) {
        if failLoad {
            completion(.failure(TestError.stub))
        } else {
            completion(.success(Order(id: "1", nfts: current)))
        }
    }

    func updateOrder(nftIds: [String], completion: @escaping OrderCompletion) {
        updateCallCount += 1
        guard !holdCompletion else { return }
        if shouldFail {
            completion(.failure(TestError.stub))
        } else {
            current = nftIds
            completion(.success(Order(id: "1", nfts: nftIds)))
        }
    }
}

final class StubProfileService: ProfileService {
    var holdCompletion = false
    var shouldFail = false
    var failLoad = false
    private(set) var updateCallCount = 0
    private var current: [String] = []

    func loadProfile(completion: @escaping ProfileCompletion) {
        if failLoad {
            completion(.failure(TestError.stub))
        } else {
            completion(.success(makeProfile(likes: current)))
        }
    }

    func updateLikes(likeIds: [String], completion: @escaping ProfileCompletion) {
        updateCallCount += 1
        guard !holdCompletion else { return }
        if shouldFail {
            completion(.failure(TestError.stub))
        } else {
            current = likeIds
            completion(.success(makeProfile(likes: likeIds)))
        }
    }

    private func makeProfile(likes: [String]) -> Profile {
        Profile(
            id: "1",
            name: "Студентус",
            avatar: nil,
            description: nil,
            website: nil,
            nfts: [],
            likes: likes
        )
    }
}

final class StubUserService: UserService {
    var user: User?

    func loadUser(id: String, completion: @escaping UserCompletion) {
        if let user {
            completion(.success(user))
        } else {
            completion(.failure(TestError.stub))
        }
    }
}
