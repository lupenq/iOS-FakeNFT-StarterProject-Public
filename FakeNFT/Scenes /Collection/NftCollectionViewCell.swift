import Kingfisher
import UIKit

final class NftCollectionViewCell: UICollectionViewCell, ReuseIdentifying {

    // MARK: - Callbacks

    var onLikeTap: (() -> Void)?
    var onCartTap: (() -> Void)?

    // MARK: - UI

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.accessibilityIdentifier = "nft.likeButton"
        button.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        return button
    }()

    private lazy var ratingView = RatingView()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textPrimary
        return label
    }()

    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .closeButton
        button.accessibilityIdentifier = "nft.cartButton"
        button.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
        return button
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
        nftImageView.kf.cancelDownloadTask()
        nftImageView.image = nil
        onLikeTap = nil
        onCartTap = nil
    }

    // MARK: - Configuration

    func configure(
        with model: NftCellModel,
        isLiked: Bool,
        isInCart: Bool,
        likeEnabled: Bool,
        cartEnabled: Bool
    ) {
        nftImageView.kf.setImage(with: model.imageURL)
        nameLabel.text = model.name
        priceLabel.text = model.priceText
        ratingView.rating = model.rating

        likeButton.tintColor = isLiked ? .ypLikeActive : .ypLikeInactive
        likeButton.isEnabled = likeEnabled
        likeButton.alpha = likeEnabled ? 1 : 0.5
        // accessibilityValue — детерминированный признак состояния для UI-тестов.
        likeButton.accessibilityValue = isLiked ? "liked" : "notLiked"

        let cartImage = isInCart
            ? UIImage(named: "cartDelete")
            : UIImage(named: "cartAdd")
        cartButton.setImage(cartImage, for: .normal)
        cartButton.isEnabled = cartEnabled
        cartButton.alpha = cartEnabled ? 1 : 0.5
        cartButton.accessibilityValue = isInCart ? "inCart" : "notInCart"
    }

    // MARK: - Actions

    @objc
    private func likeTapped() {
        onLikeTap?()
    }

    @objc
    private func cartTapped() {
        onCartTap?()
    }

    // MARK: - Private

    private func setupLayout() {
        contentView.backgroundColor = .clear

        [nftImageView, likeButton, ratingView, nameLabel, priceLabel, cartButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),

            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.heightAnchor.constraint(equalToConstant: 42),

            ratingView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 12),

            nameLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: cartButton.leadingAnchor, constant: -4),

            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),

            cartButton.centerYAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
