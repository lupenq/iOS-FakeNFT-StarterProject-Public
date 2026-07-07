//
//  CartCell.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 18.06.2026.
//

import UIKit
import Kingfisher

protocol CartCellDelegate: AnyObject {
    func cartCellDidButtonDeleteTapped(_ cell: CartCell)
}

final class CartCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Public Properties
    
    weak var delegate: CartCellDelegate?
    
    // MARK: - Private Properties
    
    private lazy var nftImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 108, height: 108))
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var nftTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = UIColor.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var nftRatingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var nftPriceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = UIColor.textPrimary
        label.text = "Цена"
        return label
    }()
    
    private lazy var nftPriceValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = UIColor.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var nftDeleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .basketDelete), for: .normal)
        button.tintColor = UIColor.textPrimary
        button.addTarget(
            self,
            action: #selector(nftDeleteButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private var nftStarButtons: [UIButton] = []
    private var nftRating: Int = 0 {
        didSet { updateStars() }
    }
    private var currentImageUrl: URL?
    
    // MARK: - Initialisers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.image = nil
        nftRating = 0
        currentImageUrl = nil
    }
    
    // MARK: - Public Methods
    
    func configure(with item: NFTUIItem) {
        nftTitleLabel.text = item.title
        nftPriceValueLabel.text = "\(item.price) ETH"
        nftRating = item.rating
        
        guard let url = item.imageUrl else { return }
        currentImageUrl = url
        nftImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { [weak self] result in
            guard let self else { return }
            
            if self.currentImageUrl == url {
                switch result {
                case .success(let value):
                    self.nftImageView.image = value.image
                case .failure(let error):
                    print("❌ Failed to load image: \(error)")
                }
            }
        }
    }
    
    func configureCell(with item: NFTItem) {
        nftImageView.image = item.image
        nftTitleLabel.text = item.title
        nftRating = item.rating
        nftPriceValueLabel.text = "\(item.price) ETH"
    }
    
    // MARK: - Private Methods
    
    @objc private func nftDeleteButtonTapped() {
        delegate?.cartCellDidButtonDeleteTapped(self)
    }
    
    private func updateStars() {
        for button in nftStarButtons {
            button.isSelected = button.tag <= nftRating
        }
    }
    
    // MARK: - Private Methods UI
    
    private func setupUI() {
        contentView.addSubview(nftImageView)
        contentView.addSubview(nftTitleLabel)
        contentView.addSubview(nftRatingStackView)
        contentView.addSubview(nftPriceTitleLabel)
        contentView.addSubview(nftPriceValueLabel)
        contentView.addSubview(nftDeleteButton)
        
        [nftImageView, nftTitleLabel, nftRatingStackView, nftPriceTitleLabel, nftPriceValueLabel, nftDeleteButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        for i in 1...5 {
            let button = UIButton(type: .custom)
            button.tag = i
            button.setImage(UIImage(resource: .starNoActive), for: .normal)
            button.setImage(UIImage(resource: .starActive), for: .selected)
            
            button.widthAnchor.constraint(equalToConstant: 12).isActive = true
            button.heightAnchor.constraint(equalToConstant: 12).isActive = true
            
            nftRatingStackView.addArrangedSubview(button)
            nftStarButtons.append(button)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            nftTitleLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftTitleLabel.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 8),
            
            nftRatingStackView.leadingAnchor.constraint(equalTo: nftTitleLabel.leadingAnchor),
            nftRatingStackView.topAnchor.constraint(equalTo: nftTitleLabel.bottomAnchor, constant: 4),
            
            nftPriceTitleLabel.leadingAnchor.constraint(equalTo: nftTitleLabel.leadingAnchor),
            nftPriceTitleLabel.topAnchor.constraint(equalTo: nftRatingStackView.bottomAnchor, constant: 12),
            
            nftPriceValueLabel.leadingAnchor.constraint(equalTo: nftPriceTitleLabel.leadingAnchor),
            nftPriceValueLabel.topAnchor.constraint(equalTo: nftPriceTitleLabel.bottomAnchor, constant: 2),
            nftPriceValueLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            
            nftDeleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nftDeleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftDeleteButton.widthAnchor.constraint(equalToConstant: 40),
            nftDeleteButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
