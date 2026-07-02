import Foundation

protocol ProfileServiceProtocol {
    func loadProfile(completion: @escaping (Result<Profile, Error>) -> Void)
    func updateProfile(with dto: ProfileUpdateDto, completion: @escaping (Result<Profile, Error>) -> Void)
}

final class ProfileDetailsService: ProfileServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
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
