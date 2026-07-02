import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void
typealias NftsCompletion = (Result<[Nft], Error>) -> Void

protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
    func fetchNFTs(with ids: [String], completion: @escaping (Result<[Nft], Error>) -> Void)
}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchNFTs(with ids: [String], completion: @escaping (Result<[Nft], Error>) -> Void) {
        guard !ids.isEmpty else {
            completion(.success([]))
            return
        }
        
        // 1. Сначала смотрим кэш
        var cached: [Nft] = []
        var missingIds: [String] = []
        
        for id in ids {
            if let nft = storage.getNft(with: id) {
                cached.append(nft)
            } else {
                missingIds.append(id)
            }
        }
        
        if missingIds.isEmpty {
            // Всё есть в кэше
            completion(.success(cached))
            return
        }
        
        // 2. Если чего-то не хватает — идём в сеть одним запросом
        let request = NftListRequest(ids: missingIds)
        
        networkClient.send(request: request, type: [Nft].self) { result in
            switch result {
            case .success(let fetched):
                // Сохраняем в кэш всё, что пришло (на случай, если сервер вернул не все запрошенные ID)
                for nft in fetched {
                    self.storage.saveNft(nft)
                }
                
                // Формируем итоговый список в том же порядке, что и запросили
                let idToNft = Dictionary(uniqueKeysWithValues: fetched.map { ($0.id, $0) })
                let orderedResult = ids.compactMap { idToNft[$0] }
                
                completion(.success(orderedResult))
                
            case .failure(let error):
                // Можно вернуть частично успешный результат (кэш + ошибка), если бизнес требует
                if !cached.isEmpty {
                    // Например, вернуть то, что есть, и залогировать ошибку
                    print("NFT fetch partially failed: \(error)")
                    completion(.success(cached))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}
