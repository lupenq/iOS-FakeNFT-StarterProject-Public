//
//  FavouritesViewController.swift
//  FakeNFT
//
//  Created by Данил Третьяченко on 29.06.2026.
//

import UIKit

final class FavouritesViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: FavouritesViewModel
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 7
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.register(FavouritesNftCell.self, forCellWithReuseIdentifier: FavouritesNftCell.identifier)
        collection.dataSource = self
        collection.delegate = self
        collection.contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var emptyPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас еще нет избранных NFT"
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
    init(viewModel: FavouritesViewModel) {
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
        
        viewModel.loadFavourites()
    }
    
    // MARK: - Private Methods
    private func setupNavigation() {
        title = "Избранные NFT"
        navigationController?.navigationBar.tintColor = UIColor.label
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        view.addSubview(emptyPlaceholderLabel)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
                let isEmpty = self.viewModel.favouritesNfts.isEmpty
                self.emptyPlaceholderLabel.isHidden = !isEmpty
                self.collectionView.isHidden = isEmpty
                self.collectionView.reloadData()
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
}

// MARK: - UICollectionViewDataSource
extension FavouritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favouritesNfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavouritesNftCell.identifier,
            for: indexPath
        ) as? FavouritesNftCell else {
            return UICollectionViewCell()
        }
        
        let nft = viewModel.favouritesNfts[indexPath.item]
        cell.configure(with: nft)
        
        cell.onLikeButtonTapped = { [weak self] in
            self?.viewModel.removeNftFromFavourites(at: indexPath.item)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavouritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
       
        let availableWidth = collectionView.bounds.width - 32 - 7
        let cellWidth = availableWidth / 2
        
       
        return CGSize(width: cellWidth, height: 80)
    }
}
