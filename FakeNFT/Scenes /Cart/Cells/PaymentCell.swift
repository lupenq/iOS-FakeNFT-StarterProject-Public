//
//  PaymentCell.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 21.06.2026.
//

import UIKit

final class PaymentCell: UICollectionViewCell, ReuseIdentifying {
    // MARK: - Public Properties
    
    
    
    // MARK: - Private Properties
    
    private lazy var currencyImageView: UIImageView = {
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private lazy var currencyTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = UIColor.textPrimary
        return label
    }()
    
    private lazy var currencyAcronymTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = UIColor.greenUniversal
        return label
    }()
    
    
    // MARK: - Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellBackground()
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Override Methods
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? 1 : 0
            contentView.layer.borderColor = isSelected ?  UIColor.black.cgColor : UIColor.segmentInactive.cgColor
        }
    }
    
    // MARK: - Public Methods
    
    func configure(with item: PaymentMethod) {
        if let url = URL(string: item.image) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.currencyImageView.image = image
                    }
                }
            }.resume()
        } else {
            currencyImageView.image = nil
        }
        
        currencyTitleLabel.text = item.title
        currencyAcronymTitleLabel.text = item.name
    }
    
    
    // MARK: - Private Methods
    
    private func configureCellBackground() {
        contentView.backgroundColor = .segmentInactive
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
    }
    
    // MARK: - Private Methods UI
    
    private func setupUI() {
        contentView.addSubview(currencyImageView)
        contentView.addSubview(textStackView)
        textStackView.addArrangedSubview(currencyTitleLabel)
        textStackView.addArrangedSubview(currencyAcronymTitleLabel)
        
        [currencyImageView, textStackView, currencyTitleLabel, currencyAcronymTitleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            currencyImageView.widthAnchor.constraint(equalToConstant: 36),
            currencyImageView.heightAnchor.constraint(equalToConstant: 36),
            currencyImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            currencyImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            currencyImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            textStackView.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4)
        ])
    }
}
