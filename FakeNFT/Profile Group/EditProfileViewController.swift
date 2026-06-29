import UIKit
import Kingfisher

protocol EditProfileViewControllerDelegate: AnyObject {
    func didSaveProfile(name: String?, description: String?, website: String?, avatarURLString: String?)
}

final class EditProfileViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: EditProfileViewControllerDelegate?
    private var currentAvatarURLString: String?
    
    // MARK: - UI Elements
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor.label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сменить\nфото", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 35
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(changePhotoButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nameLabel: UILabel = createFieldLabel(text: "Имя")
    private lazy var nameTextField: UITextField = createTextField(placeholder: "Введите имя")
    
    private lazy var descriptionLabel: UILabel = createFieldLabel(text: "Описание")
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .bodyRegular // ✅ Исправлено по ревью: Дизайн-система шрифтов
        textView.layer.cornerRadius = 12
        textView.backgroundColor = .systemGray6
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var websiteLabel: UILabel = createFieldLabel(text: "Сайт")
    private lazy var websiteTextField: UITextField = createTextField(placeholder: "Введите ссылку на сайт")
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.label
        button.titleLabel?.font = .bodyBold // ✅ Исправлено по ревью: Дизайн-система шрифтов
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupKeyboardDismissal()
    }
    
    // MARK: - Public Configuration
    func configure(name: String?, description: String?, website: String?, avatarURLString: String?) {
        nameTextField.text = name
        descriptionTextView.text = description
        websiteTextField.text = website
        self.currentAvatarURLString = avatarURLString
        
        let placeholderImage = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        
        if let avatarURLString {
            let secureAvatarString = avatarURLString.replacingOccurrences(of: "http://", with: "https://")
            if let url = URL(string: secureAvatarString) {
                avatarImageView.kf.setImage(with: url, placeholder: placeholderImage)
            }
        } else {
            avatarImageView.image = placeholderImage
        }
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(closeButton)
        view.addSubview(avatarImageView)
        view.addSubview(changePhotoButton)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(websiteLabel)
        view.addSubview(websiteTextField)
        view.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Кнопка закрыть
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Аватарка и кнопка поверх неё
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            changePhotoButton.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            changePhotoButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            changePhotoButton.widthAnchor.constraint(equalToConstant: 70),
            changePhotoButton.heightAnchor.constraint(equalToConstant: 70),
            
            // Поле: Имя
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Поле: Описание
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 132),
            
            // Поле: Сайт
            websiteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            websiteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            websiteTextField.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 8),
            websiteTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            websiteTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Кнопка Сохранить
            saveButton.topAnchor.constraint(equalTo: websiteTextField.bottomAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func changePhotoButtonTapped() {
        let alertController = UIAlertController(
            title: "Изменить фото",
            message: "Введите ссылку на новую аватарку",
            preferredStyle: .alert
        )
        
        alertController.addTextField { [weak self] textField in
            guard let self else { return } // ✅ Исправлено по ревью: укороченный синтаксис Swift 5.7+
            textField.placeholder = "https://example.com/avatar.png"
            textField.text = self.currentAvatarURLString
            textField.keyboardType = .URL
        }
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self else { return } // ✅ Исправлено по ревью: укороченный синтаксис Swift 5.7+
            guard let textField = alertController.textFields?.first,
                  let text = textField.text, !text.isEmpty else { return }
            
            self.currentAvatarURLString = text
            let secureString = text.replacingOccurrences(of: "http://", with: "https://")
            let placeholder = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            
            if let url = URL(string: secureString) {
                self.avatarImageView.kf.setImage(with: url, placeholder: placeholder)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc private func saveButtonTapped() {
        delegate?.didSaveProfile(
            name: nameTextField.text,
            description: descriptionTextView.text,
            website: websiteTextField.text,
            avatarURLString: currentAvatarURLString
        )
        dismiss(animated: true)
    }
    
    // MARK: - Helpers
    private func createFieldLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 12
        textField.placeholder = placeholder
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
