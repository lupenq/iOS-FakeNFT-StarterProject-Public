import Foundation

enum ProfileState {
    case initial
    case loading
    case data(Profile)
    case failed(Error)
}

final class ProfileViewModel {
    
    // MARK: - Properties
    private let profileService: ProfileServiceProtocol
    
    var onChange: (() -> Void)?
    
    private(set) var state: ProfileState = .initial {
        didSet {
            onChange?()
        }
    }
    
    // MARK: - Initialization
    init(profileService: ProfileServiceProtocol = ProfileDetailsService()) {
        self.profileService = profileService
    }
    
    // MARK: - Public Methods
    
    func loadProfile() {
        state = .loading
        profileService.loadProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.state = .data(profile)
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
    
   
    func updateProfile(name: String, description: String?, website: String?, avatar: String?) {
       
        guard case .data(let currentProfile) = state else { return }
        
        let dto = ProfileUpdateDto(
            name: name,
            description: description ?? "",
            website: website ?? "",
            avatar: avatar ?? ""
        )
        
        state = .loading
        profileService.updateProfile(with: dto) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let updatedProfile):
               
                self.state = .data(updatedProfile)
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
}
