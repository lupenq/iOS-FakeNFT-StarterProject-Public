import Foundation

// Протокол для сервиса, чтобы легко тестировать или подменять ViewModel
protocol ProfileServiceProtocol {
    func loadProfile(completion: @escaping (Result<Profile, Error>) -> Void)
    func updateProfile(with dto: ProfileUpdateDto, completion: @escaping (Result<Profile, Error>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {
    
    private let networkClient: NetworkClient
    
    // Инжектим стандартный NetworkClient проекта
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    // 1. Загрузка профиля (GET)
    func loadProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = ProfileRequest()
        
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 2. Обновление профиля (PUT)
    func updateProfile(with dto: ProfileUpdateDto, completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = ProfileUpdateRequest(updateDto: dto)
        
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let updatedProfile):
                completion(.success(updatedProfile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
