//
//  DeleteModalViewController.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 19.06.2026.
//

import UIKit

final class DeleteModalViewController: UIViewController {
    // MARK: - Private Properties
    
    private lazy var nftImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nftTitle: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textPrimary
        label.text = NSLocalizedString("DeleteModalVC.title", comment: "")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(NSLocalizedString("DeleteModalVC.deleteButton", comment: ""), for: .normal)
        btn.titleLabel?.font = .bodyRegular
        btn.tintColor = .redUniversal
        btn.backgroundColor = .segmentActive
        btn.layer.cornerRadius = 12
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(NSLocalizedString("DeleteModalVC.backButton", comment: ""), for: .normal)
        btn.titleLabel?.font = .bodyRegular
        btn.tintColor = .textOnPrimary
        btn.backgroundColor = .segmentActive
        btn.layer.cornerRadius = 12
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var stackButton: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    
    private let onDelete: () -> Void
    
    // MARK: - Initialisers
    
    init(
        image: UIImage?,
        onDelete: @escaping () -> Void
    ) {
        self.onDelete = onDelete
        super.init(nibName: nil, bundle: nil)
        self.nftImage.image = image
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlur()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    
    @objc private func deleteButtonTapped() {
        
        dismiss(animated: true) { [weak self] in
            self?.onDelete()
        }
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods UI
    private func setupBlur() {
        view.backgroundColor = .background.withAlphaComponent(0.05)
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.constraintEdges(to: view)
    }
    
    private func setupUI() {
        view.addSubview(nftImage)
        view.addSubview(nftTitle)
        view.addSubview(stackButton)
        stackButton.addArrangedSubview(deleteButton)
        stackButton.addArrangedSubview(backButton)
        
        [nftImage, nftTitle, stackButton, deleteButton, backButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImage.widthAnchor.constraint(equalToConstant: 108),
            nftImage.heightAnchor.constraint(equalToConstant: 108),
            nftImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            
            nftTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftTitle.topAnchor.constraint(equalTo: nftImage.bottomAnchor, constant: 12),
            
            stackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackButton.topAnchor.constraint(equalTo: nftTitle.bottomAnchor, constant: 20),
            stackButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
}
