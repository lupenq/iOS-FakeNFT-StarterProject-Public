//
//  CartController.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 18.06.2026.
//

import UIKit

final class CartController: UIViewController {
    
    // MARK: - Public Properties
    
    let servicesAssembly: ServicesAssembly
    
    
    // MARK: - Private Properties
    
    private lazy var cartTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartCell.self)
        return tableView
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
        cartTableView.dataSource = self
        cartTableView.delegate = self
        
        view.backgroundColor = .background
        
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    
    // MARK: - Private Methods UI
    private func setupUI() {
        view.addSubview(cartTableView)
    }
    
    private func setupConstraints() {
        cartTableView.constraintEdges(to: view)
    }
    
}

// MARK: - UITableViewDataSource

extension CartController: UITableViewDataSource {
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

extension CartController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(140)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Выбрана ячейка под номером: \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


