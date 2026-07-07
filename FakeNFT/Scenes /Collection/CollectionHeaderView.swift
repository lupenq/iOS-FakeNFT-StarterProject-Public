import Kingfisher
import UIKit

struct CollectionHeaderModel {
    let coverURL: URL
    let title: String
    let authorName: String
    let description: String
}

final class CollectionHeaderView: UICollectionReusableView, ReuseIdentifying {

    static var defaultReuseIdentifier: String { "CollectionHeaderView" }

    // MARK: - Callbacks

    var onAuthorTap: (() -> Void)?

    // MARK: - UI

    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private lazy var authorPrefixLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textPrimary
        label.text = NSLocalizedString("Collection.author", comment: "")
        return label
    }()

    private lazy var authorButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .caption1
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.accessibilityIdentifier = "collection.authorButton"
        button.addTarget(self, action: #selector(authorTapped), for: .touchUpInside)
        return button
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.kf.cancelDownloadTask()
        coverImageView.image = nil
        onAuthorTap = nil
    }

    // MARK: - Configuration

    func configure(with model: CollectionHeaderModel) {
        coverImageView.kf.setImage(with: model.coverURL)
        applyText(model)
    }

    func applyText(_ model: CollectionHeaderModel) {
        titleLabel.text = model.title
        authorButton.setTitle(model.authorName, for: .normal)
        descriptionLabel.text = model.description
    }

    // MARK: - Actions

    @objc
    private func authorTapped() {
        onAuthorTap?()
    }

    // MARK: - Private

    private func setupLayout() {
        backgroundColor = .systemBackground

        [coverImageView, titleLabel, authorPrefixLabel, authorButton, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        authorPrefixLabel.setContentHuggingPriority(.required, for: .horizontal)
        authorPrefixLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 310),

            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            authorPrefixLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13),
            authorPrefixLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            authorButton.firstBaselineAnchor.constraint(equalTo: authorPrefixLabel.firstBaselineAnchor),
            authorButton.leadingAnchor.constraint(equalTo: authorPrefixLabel.trailingAnchor, constant: 4),
            authorButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: authorPrefixLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
