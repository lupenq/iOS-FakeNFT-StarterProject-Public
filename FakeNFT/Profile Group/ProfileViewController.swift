import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: ProfileViewModel
    private let menuItems = ["Мои NFT", "Избранные NFT", "О разработчике"]
    
    // MARK: - UI Elements
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3 // ✅ Исправлено по ревью: Дизайн-система шрифтов
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var websiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 54
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = UIColor.label
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Initialization
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // ✅ Исправлено по ревью: убран fatalError, исключен аварийный выход
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
        
        viewModel.loadProfile()
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        // ✅ Исправлено по ревью: удален очевидный комментарий
        let editButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(editButtonTapped)
        )
        editButton.tintColor = UIColor.label
        navigationItem.rightBarButtonItem = editButton
        
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(websiteButton)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        // ✅ Исправлено по ревью: удалены все избыточные комментарии к констрейнтам
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            websiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 54 * 3),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        viewModel.onChange = { [weak self] in
            guard let self else { return } // ✅ Исправлено по ревью: укороченный синтаксис
            
            DispatchQueue.main.async {
                switch self.viewModel.state {
                case .initial:
                    self.activityIndicator.stopAnimating()
                case .loading:
                    self.activityIndicator.startAnimating()
                    print("--- [Profile] Запрос ушел на server... ---")
                case .data(let profile):
                    self.activityIndicator.stopAnimating()
                    print("--- [Profile] Данные успешно получены: \(profile.name) ---")
                    self.updateUI(with: profile)
                case .failed(let error):
                    self.activityIndicator.stopAnimating()
                    print("❌ [Profile] Ошибка сети: \(error.localizedDescription)")
                    self.showErrorAlert(with: error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI(with profile: Profile) {
        self.nameLabel.text = profile.name
        self.descriptionLabel.text = profile.description
        self.websiteButton.setTitle(profile.website, for: .normal)
        
        let placeholderImage = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        
        if let avatarString = profile.avatar {
            let secureAvatarString = avatarString.replacingOccurrences(of: "http://", with: "https://")
            if let avatarURL = URL(string: secureAvatarString) {
                
                self.avatarImageView.kf.setImage(
                    with: avatarURL,
                    placeholder: placeholderImage,
                    options: [.transition(.fade(0.2))]
                ) { result in
                    if case .failure = result {
                        DispatchQueue.main.async {
                            self.avatarImageView.image = placeholderImage
                        }
                    }
                }
            }
        } else {
            self.avatarImageView.image = placeholderImage
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Error Presentation
    private func showErrorAlert(with message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Не удалось загрузить или сохранить данные профиля.\n(\(message))",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func websiteButtonTapped() {
        guard case .data(let profile) = viewModel.state else { return }
        
        guard let websiteString = profile.website,
              let url = URL(string: websiteString) else {
            print("❌ [Profile] Некорректный или отсутствующий URL сайта")
            return
        }
        
        let websiteVC = ProfileWebsiteViewController(url: url)
        websiteVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(websiteVC, animated: true)
    }
    
    @objc private func editButtonTapped() {
        guard case .data(let profile) = viewModel.state else { return }
        
        let editVC = EditProfileViewController()
        editVC.delegate = self
        
        editVC.configure(
            name: profile.name,
            description: profile.description,
            website: profile.website,
            avatarURLString: profile.avatar
        )
        
        editVC.modalPresentationStyle = .pageSheet
        present(editVC, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.textProperties.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        content.textProperties.color = UIColor.label
        
        var nftsCount = 0
        var likesCount = 0
        
        if case .data(let profile) = viewModel.state {
            nftsCount = profile.nfts.count
            likesCount = profile.likes.count
        }
        
        switch indexPath.row {
        case 0:
            content.text = "Мои NFT (\(nftsCount))"
        case 1:
            content.text = "Избранные NFT (\(likesCount))"
        case 2:
            content.text = "О разработчике"
        default:
            content.text = menuItems[indexPath.row]
        }
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard case .data(let profile) = viewModel.state else { return }
        
        switch indexPath.row {
        case 0:
            let myNftsVC = MyNftsViewController()
            myNftsVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(myNftsVC, animated: true)
            
        case 1:
            let favouritesVC = FavouritesViewController()
            favouritesVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(favouritesVC, animated: true)
            
        case 2:
            guard let websiteString = profile.website,
                  let url = URL(string: websiteString) else { return }
            let websiteVC = ProfileWebsiteViewController(url: url)
            websiteVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(websiteVC, animated: true)
            
        default:
            break
        }
    }
}

// MARK: - EditProfileViewControllerDelegate
extension ProfileViewController: EditProfileViewControllerDelegate {
    func didSaveProfile(name: String?, description: String?, website: String?, avatarURLString: String?) {
        print("💾 Получены новые данные для сохранения: \(String(describing: name))")
        
        viewModel.updateProfile(
            name: name ?? "",
            description: description ?? "",
            website: website ?? "",
            avatar: avatarURLString ?? ""
        )
    }
}
