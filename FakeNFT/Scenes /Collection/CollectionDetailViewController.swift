import UIKit

/// TODO: подфича 3
final class CollectionDetailViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: CollectionDetailViewModelProtocol

    // MARK: - Init

    init(viewModel: CollectionDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        viewModel.viewDidLoad()
    }
}
