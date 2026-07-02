import ProgressHUD
import UIKit

final class CollectionDetailViewController: UIViewController, LoadingView, ErrorView {

    // MARK: - Layout constants

    private enum Layout {
        static let columns: CGFloat = 3
        static let sideInset: CGFloat = 16
        static let interItemSpacing: CGFloat = 9
        static let lineSpacing: CGFloat = 8
        static let cellExtraHeight: CGFloat = 68
    }

    // MARK: - Properties

    private let viewModel: CollectionDetailViewModelProtocol
    private let servicesAssembly: ServicesAssembly

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Layout.lineSpacing
        layout.minimumInteritemSpacing = Layout.interItemSpacing
        layout.sectionInset = UIEdgeInsets(top: 8, left: Layout.sideInset, bottom: 40, right: Layout.sideInset)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NftCollectionViewCell.self)
        collectionView.register(
            CollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionHeaderView.defaultReuseIdentifier
        )
        return collectionView
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var sizingHeader = CollectionHeaderView()

    private var savedStandardAppearance: UINavigationBarAppearance?
    private var savedScrollEdgeAppearance: UINavigationBarAppearance?
    private var savedTintColor: UIColor?

    private var cachedHeaderHeight: CGFloat?
    private var cachedHeaderWidth: CGFloat = 0

    // MARK: - Init

    init(viewModel: CollectionDetailViewModelProtocol, servicesAssembly: ServicesAssembly) {
        self.viewModel = viewModel
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyTransparentNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        restoreNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottom = view.safeAreaInsets.bottom
        if collectionView.contentInset.bottom != bottom {
            collectionView.contentInset.bottom = bottom
        }
    }

    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(collectionView)
        collectionView.constraintEdges(to: view)

        view.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: view)
    }

    private func applyTransparentNavigationBar() {
        guard let bar = navigationController?.navigationBar else { return }
        savedStandardAppearance = bar.standardAppearance
        savedScrollEdgeAppearance = bar.scrollEdgeAppearance
        savedTintColor = bar.tintColor

        let transparent = UINavigationBarAppearance()
        transparent.configureWithTransparentBackground()
        bar.standardAppearance = transparent
        bar.scrollEdgeAppearance = transparent
        bar.tintColor = .closeButton
    }

    private func restoreNavigationBar() {
        guard let bar = navigationController?.navigationBar else { return }
        if let savedStandardAppearance {
            bar.standardAppearance = savedStandardAppearance
        }
        bar.scrollEdgeAppearance = savedScrollEdgeAppearance
        bar.tintColor = savedTintColor
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            switch state {
            case .initial:
                break
            case .loading:
                self.showLoading()
            case .data:
                self.hideLoading()
                self.cachedHeaderHeight = nil
                self.collectionView.reloadData()
            case .failed(let error):
                self.hideLoading()
                self.showLoadError(error)
            }
        }

        viewModel.onNftChange = { [weak self] index in
            guard let self else { return }
            self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }

        viewModel.onProcessingChange = { isProcessing in
            if isProcessing {
                ProgressHUD.show(interaction: false)
            } else {
                ProgressHUD.dismiss()
            }
        }

        viewModel.onActionError = { [weak self] _ in
            self?.showActionError()
        }
    }

    private func showLoadError(_ error: Error) {
        let model = ErrorModel(
            message: NSLocalizedString("Error.network", comment: ""),
            actionText: NSLocalizedString("Error.repeat", comment: "")
        ) { [weak self] in
            self?.viewModel.reload()
        }
        showError(model)
    }

    private func showActionError() {
        let alert = UIAlertController(
            title: NSLocalizedString("Error.title", comment: ""),
            message: NSLocalizedString("Error.network", comment: ""),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("Error.ok", comment: ""), style: .default))
        present(alert, animated: true)
    }

    private func openAuthorWebsite() {
        guard let url = viewModel.authorWebsite else { return }
        let webViewController = WebViewController(url: url)
        navigationController?.pushViewController(webViewController, animated: true)
    }

    private func itemWidth(for collectionView: UICollectionView) -> CGFloat {
        let available = collectionView.bounds.width
            - Layout.sideInset * 2
            - Layout.interItemSpacing * (Layout.columns - 1)
        return (available / Layout.columns).rounded(.down)
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionDetailViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfNfts
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: NftCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let index = indexPath.item
        cell.configure(
            with: viewModel.cellModel(at: index),
            isLiked: viewModel.isLiked(at: index),
            isInCart: viewModel.isInCart(at: index),
            likeEnabled: viewModel.canToggleLikes,
            cartEnabled: viewModel.canToggleCart
        )
        cell.onLikeTap = { [weak self] in self?.viewModel.toggleLike(at: index) }
        cell.onCartTap = { [weak self] in self?.viewModel.toggleCart(at: index) }
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CollectionHeaderView.defaultReuseIdentifier,
                for: indexPath
            ) as? CollectionHeaderView,
            let model = viewModel.headerModel
        else {
            return UICollectionReusableView()
        }
        header.configure(with: model)
        header.onAuthorTap = { [weak self] in self?.openAuthorWebsite() }
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = itemWidth(for: collectionView)
        return CGSize(width: width, height: width + Layout.cellExtraHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        guard let model = viewModel.headerModel else { return .zero }
        let width = collectionView.bounds.width

        if let cachedHeaderHeight, cachedHeaderWidth == width {
            return CGSize(width: width, height: cachedHeaderHeight)
        }

        sizingHeader.applyText(model)
        let target = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        let height = sizingHeader.systemLayoutSizeFitting(
            target,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height

        cachedHeaderHeight = height
        cachedHeaderWidth = width
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.nftId(at: indexPath.item)
        let assembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
        let nftViewController = assembly.build(with: NftDetailInput(id: id))
        nftViewController.modalPresentationStyle = .fullScreen
        present(nftViewController, animated: true)
    }
}
