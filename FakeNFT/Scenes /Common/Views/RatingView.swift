import UIKit

final class RatingView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let maxRating = 5
        static let starSize: CGFloat = 12
        static let spacing: CGFloat = 2
    }

    // MARK: - Properties

    var rating: Int = 0 {
        didSet { updateStars() }
    }

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.spacing
        stack.alignment = .center
        return stack
    }()

    private lazy var starImageViews: [UIImageView] = (0..<Constants.maxRating).map { _ in
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.starSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.starSize)
        ])
        return imageView
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        updateStars()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setupLayout() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        starImageViews.forEach { stackView.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func updateStars() {
        let clamped = max(0, min(rating, Constants.maxRating))
        for (index, imageView) in starImageViews.enumerated() {
            imageView.tintColor = index < clamped ? .ypRatingActive : .ypRatingInactive
        }
    }
}
