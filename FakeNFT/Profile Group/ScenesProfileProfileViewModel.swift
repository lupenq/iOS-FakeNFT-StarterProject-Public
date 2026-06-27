import Foundation

// Состояния экрана для обработки во View
enum ProfileState {
    case initial
    case loading
    case data(Profile)
    case failed(Error)
}

final class ProfileViewModel {
    
    // MARK: - Properties
    private let profileService: ProfileServiceProtocol
    
    // Замыкание, на которое подпишется ViewController для обновления интерфейса
    var onChange: (() -> Void)?
    
    // Текущее состояние экрана. При его изменении автоматически триггерится замыкание
    private(set) var state: ProfileState = .initial {
        didSet {
            onChange?()
        }
    }
    
    // MARK: - Initialization
    init(profileService: ProfileServiceProtocol = ProfileService()) {
        self.profileService = profileService
    }
    
    // MARK: - Public Methods
    
    /// Загрузка данных профиля (GET)
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
    
    /// Обновление данных профиля (PUT)
    func updateProfile(name: String, description: String?, website: String?, avatar: String?) {
        // Запрос на обновление можно отправить только если данные уже были один раз успешно загружены
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
                // Сервер возвращает обновленный профиль, прокидываем его в состояние .data
                self.state = .data(updatedProfile)
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
}
