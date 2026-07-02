import Foundation

typealias CollectionsCompletion = (Result<[NftCollection], Error>) -> Void
typealias CollectionCompletion = (Result<NftCollection, Error>) -> Void
typealias NftsCompletion = (Result<[Nft], Error>) -> Void

protocol CollectionService {
    func loadCollections(completion: @escaping CollectionsCompletion)
    func loadCollection(id: String, completion: @escaping CollectionCompletion)
    func loadNfts(ids: [String], completion: @escaping NftsCompletion)
}

final class CollectionServiceImpl: CollectionService {

    private let networkClient: NetworkClient
    private let nftService: NftService

    init(networkClient: NetworkClient, nftService: NftService) {
        self.networkClient = networkClient
        self.nftService = nftService
    }

    func loadCollections(completion: @escaping CollectionsCompletion) {
        let request = CollectionsRequest()
        networkClient.send(request: request, type: [NftCollection].self) { result in
            switch result {
            case .success(let collections):
                completion(.success(collections))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadCollection(id: String, completion: @escaping CollectionCompletion) {
        let request = CollectionByIdRequest(id: id)
        networkClient.send(request: request, type: NftCollection.self) { result in
            switch result {
            case .success(let collection):
                completion(.success(collection))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadNfts(ids: [String], completion: @escaping NftsCompletion) {
        guard !ids.isEmpty else {
            completion(.success([]))
            return
        }

        let group = DispatchGroup()
        let lock = NSLock()
        var loaded: [String: Nft] = [:]
        var lastError: Error?

        for id in ids {
            group.enter()
            nftService.loadNft(id: id) { result in
                lock.lock()
                switch result {
                case .success(let nft):
                    loaded[nft.id] = nft
                case .failure(let error):
                    lastError = error
                }
                lock.unlock()
                group.leave()
            }
        }

        group.notify(queue: .main) {
            let ordered = ids.compactMap { loaded[$0] }
            if ordered.isEmpty, let lastError {
                completion(.failure(lastError))
            } else {
                completion(.success(ordered))
            }
        }
    }
}
