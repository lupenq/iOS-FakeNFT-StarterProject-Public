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
    
    private lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(resource: .sortLight),
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped)
        )
        button.tintColor = .textPrimary
        return button
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
        let deleteModalVC = DeleteModalViewController()
        deleteModalVC.modalPresentationStyle = .overFullScreen
        present(deleteModalVC, animated: true)
        //TODO: перенести в кнопку в ячейке
        print("Нажата кнопка к оплате")
    }
    
    @objc private func filterButtonTapped() {
        let priceAction = UIAlertAction(
            title: NSLocalizedString("sort.by.price", comment: ""),
            style: .default
        ) { [weak self] _ in
            print("Сортировка по цене")
        }
        
        let ratingAction = UIAlertAction(
            title: NSLocalizedString("sort.by.rating", comment: ""),
            style: .default
        ) { [weak self] _ in
            print("Сортировка по рейтингу")
        }
        
        let titleAction = UIAlertAction(
            title: NSLocalizedString("sort.by.title", comment: ""),
            style: .default
        ) { [weak self] _ in
            print("Сортировка по названию")
        }
        
        showFilterActionSheet(
            firstAction: priceAction,
            secondAction: ratingAction,
            thirdAction: titleAction
        )
        print("Нажата кнопка фильтрации")
    }
    // MARK: - Private Methods UI
    
    private func setupUI() {
        navigationItem.rightBarButtonItem = filterButton
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


extension CartViewController {
    
    func showFilterActionSheet(
        firstAction: UIAlertAction,
        secondAction: UIAlertAction,
        thirdAction: UIAlertAction
    ) {
        let titleOfActionSheet = NSLocalizedString("filter.sort.title", comment: "")
        let alert = UIAlertController(
            title: titleOfActionSheet,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let textOfCancelButton = NSLocalizedString("common.close", comment: "")
        let cancelAction = UIAlertAction(title: textOfCancelButton, style: .cancel)
        
        [firstAction, secondAction, thirdAction, cancelAction].forEach { alert.addAction($0) }
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(
                x: self.view.bounds.midX,
                y: self.view.bounds.midY,
                width: 0,
                height: 0)
            popover.permittedArrowDirections = []
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true) {
                print("Action sheet успешно показан")
            }
        }
    }
}
