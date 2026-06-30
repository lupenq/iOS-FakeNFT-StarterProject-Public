import UIKit

final class CatalogViewController: UIViewController, LoadingView, ErrorView {

    // MARK: - Properties

    private let viewModel: CatalogViewModelProtocol
    private let servicesAssembly: ServicesAssembly

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CatalogCollectionCell.self)
        return tableView
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var sortButton: UIBarButtonItem = {
        UIBarButtonItem(
            image: UIImage(named: "sort"),
            style: .plain,
            target: self,
            action: #selector(sortTapped)
        )
    }()

    // MARK: - Init

    init(viewModel: CatalogViewModelProtocol, servicesAssembly: ServicesAssembly) {
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

    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = .systemBackground
        sortButton.tintColor = .closeButton
        navigationItem.rightBarButtonItem = sortButton

        view.addSubview(tableView)
        tableView.constraintEdges(to: view)

        view.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: view)
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
                self.tableView.reloadData()
            case .failed(let error):
                self.hideLoading()
                self.showLoadError(error)
            }
        }
    }

    private func showLoadError(_ error: Error) {
        let message = NSLocalizedString("Error.network", comment: "")
        let model = ErrorModel(
            message: message,
            actionText: NSLocalizedString("Error.repeat", comment: "")
        ) { [weak self] in
            self?.viewModel.reload()
        }
        showError(model)
    }

    @objc
    private func sortTapped() {
        let alert = UIAlertController(
            title: NSLocalizedString("Catalog.sort.title", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )

        alert.addAction(
            UIAlertAction(title: NSLocalizedString("Catalog.sort.byName", comment: ""), style: .default) { [weak self] _ in
                self?.viewModel.setSortOption(.name)
            }
        )
        alert.addAction(
            UIAlertAction(title: NSLocalizedString("Catalog.sort.byNftCount", comment: ""), style: .default) { [weak self] _ in
                self?.viewModel.setSortOption(.nftCount)
            }
        )
        alert.addAction(
            UIAlertAction(title: NSLocalizedString("Catalog.sort.close", comment: ""), style: .cancel)
        )

        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension CatalogViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCollections
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CatalogCollectionCell = tableView.dequeueReusableCell()
        cell.configure(with: viewModel.cellModel(at: indexPath.row))
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CatalogViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let collectionId = viewModel.collectionId(at: indexPath.row)
        let assembly = CollectionDetailAssembly(servicesAssembly: servicesAssembly)
        let input = CollectionDetailInput(collectionId: collectionId)
        let detailViewController = assembly.build(with: input)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
