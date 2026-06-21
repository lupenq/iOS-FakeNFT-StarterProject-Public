import Kingfisher
import UIKit

final class CatalogCollectionCell: UITableViewCell, ReuseIdentifying {

    // MARK: - Properties

    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    }

    // MARK: - Configuration

    func configure(with model: CatalogCellModel) {
        coverImageView.kf.setImage(with: model.coverURL)
        titleLabel.text = "\(model.title) (\(model.nftCount))"
    }

    // MARK: - Private

    private func setupLayout() {
        selectionStyle = .none
        backgroundColor = .clear

        [coverImageView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            coverImageView.heightAnchor.constraint(equalToConstant: 140),

            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -21)
        ])
    }
}
