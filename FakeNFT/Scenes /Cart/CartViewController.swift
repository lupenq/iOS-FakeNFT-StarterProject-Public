//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 18.06.2026.
//

import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - Public Properties
    
    let servicesAssembly: ServicesAssembly
    
    
    // MARK: - Private Properties
    
    private lazy var cartTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartCell.self)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Cart.pay.button", comment: ""), for: .normal)
        button.setTitleColor(.textOnPrimary, for: .normal)
        button.backgroundColor = .textPrimary
        button.titleLabel?.font = .bodyBold
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var nftCount: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .textPrimary
        label.text = "3 NTF"
        return label
    }()
    
    private lazy var nftTotalPrice: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .greenUniversal
        label.text = "5,34 ETH"
        return label
    }()
    
    private lazy var backgroundPayment: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .segmentInactive
        return view
    }()
    
    // MARK: - Initialisers
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupUI()
        setupConstraints()
        setupTableView()
    }
    
    // MARK: - Private Methods
    @objc private func payButtonTapped() {
        print("Нажата кнопка к оплате")
    }
    // MARK: - Private Methods UI
    private func setupUI() {
        view.addSubview(backgroundPayment)
        backgroundPayment.addSubview(payButton)
        backgroundPayment.addSubview(nftCount)
        backgroundPayment.addSubview(nftTotalPrice)
    }
    
    private func setupConstraints() {
        [backgroundPayment, payButton, nftCount, nftTotalPrice].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            backgroundPayment.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundPayment.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundPayment.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backgroundPayment.heightAnchor.constraint(equalToConstant: 76),
            
            nftCount.leadingAnchor.constraint(equalTo: backgroundPayment.leadingAnchor, constant: 16),
            nftCount.topAnchor.constraint(equalTo: backgroundPayment.topAnchor, constant: 16),
            
            nftTotalPrice.leadingAnchor.constraint(equalTo: nftCount.leadingAnchor),
            nftTotalPrice.topAnchor.constraint(equalTo: nftCount.bottomAnchor, constant: 2),
            
            payButton.topAnchor.constraint(equalTo: backgroundPayment.topAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: backgroundPayment.trailingAnchor, constant: -16),
            payButton.widthAnchor.constraint(equalToConstant: 240),
            payButton.heightAnchor.constraint(equalToConstant: 44)
            
        ])
    }
    
    private func setupTableView() {
        cartTableView.dataSource = self
        cartTableView.delegate = self
        
        view.addSubview(cartTableView)
        
        cartTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cartTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cartTableView.bottomAnchor.constraint(equalTo: backgroundPayment.topAnchor),
            cartTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartCell = tableView.dequeueReusableCell()
        cell.configureCell()
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(140)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Выбрана ячейка под номером: \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


