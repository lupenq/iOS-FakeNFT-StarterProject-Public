//
//  SuccessfulPaymentVC.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 24.06.2026.
//

import UIKit

class SuccessfulPaymentVC: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 278, height: 278))
        iv.image = UIImage(resource: .successfulPayment)
        return iv
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .textPrimary
        label.text = NSLocalizedString("Successful payment", comment: "")
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Back.to.cart", comment: ""), for: .normal)
        button.setTitleColor(.textOnPrimary, for: .normal)
        button.backgroundColor = .textPrimary
        button.titleLabel?.font = .bodyBold
        button.addTarget(self, action: #selector(backToCart), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        return button
    }()
    
    
    // MARK: - View LifyCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupUI()
        setupConstraints()
        
    }
    
    // MARK: - Private Methods
    
    @objc private func backToCart() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Private Methods UI
    
    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(button)
        
        [imageView, label, button].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
}

#Preview {
    SuccessfulPaymentVC()
}
