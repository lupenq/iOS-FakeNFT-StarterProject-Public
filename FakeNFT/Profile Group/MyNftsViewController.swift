//
//  MyNftsViewController.swift
//  FakeNFT
//
//  Created by Данил Третьяченко on 29.06.2026.
//

import UIKit

final class MyNftsViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: MyNftsViewModel
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 140
        tableView.register(MyNftCell.self, forCellReuseIdentifier: MyNftCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var emptyPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас еще нет NFT"
        label.font = .bodyBold
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = UIColor.label
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Initialization
    init(viewModel: MyNftsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
        setupConstraints()
        bindViewModel()
        
        viewModel.loadNfts()
    }
    
    // MARK: - Private Methods
    private func setupNavigation() {
        title = "Мои NFT"
        navigationController?.navigationBar.tintColor = UIColor.label
        
        let sortButton = UIBarButtonItem(
            image: UIImage(systemName: "text.justify.left"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(emptyPlaceholderLabel)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyPlaceholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyPlaceholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onChange = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.emptyPlaceholderLabel.isHidden = !self.viewModel.nfts.isEmpty
                self.tableView.isHidden = self.viewModel.nfts.isEmpty
                self.tableView.reloadData()
            }
        }
        
        viewModel.onLoadingStateChange = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                if self.viewModel.isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func sortButtonTapped() {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
            self?.viewModel.changeSort(to: .price)
        })
        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.viewModel.changeSort(to: .rating)
        })
        alert.addAction(UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.viewModel.changeSort(to: .name)
        })
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MyNftsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyNftCell.identifier, for: indexPath) as? MyNftCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.nfts[indexPath.row])
        return cell
    }
}
