//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 21.06.2026.
//

import UIKit
import ProgressHUD

enum NavigationIcon: String {
    case back = "chevron.left"
}

final class PaymentViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 7
        layout.minimumLineSpacing = 7
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PaymentCell.self)
        return collectionView
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Cart.paid.button", comment: ""), for: .normal)
        button.setTitleColor(.textOnPrimary, for: .normal)
        button.backgroundColor = .textPrimary
        button.titleLabel?.font = .bodyBold
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var userTermsTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.font = .caption2
        tv.textColor = .textPrimary
        tv.dataDetectorTypes = .link
        tv.isUserInteractionEnabled = true
        return tv
    }()
    
    private lazy var backgroundPayment: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .segmentInactive
        return view
    }()
    
    private let viewModel: PaymentViewModel
    private let terms: String = "https://yandex.ru/legal/practicum_termsofuse"
    
    // MARK: - Initialisers
    
    init(viewModel: PaymentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    init(paymentService: PaymentService, nftIds: [String]) {
        self.viewModel = PaymentViewModel(paymentService: paymentService, nftIds: nftIds)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupNavBar()
        setupTerms()
        setupUI()
        setupConstraints()
        setupCollectionView()
        bindViewModel()
        
        ProgressHUD.show()
        viewModel.loadCurrencies()
    }
    
    // MARK: - Public Methods
    
    // MARK: - BindViewModel
    
    private func bindViewModel() {
        viewModel.onItemsLoaded = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                self.collectionView.reloadData()
            }
        }
        
        viewModel.onImageLoaded = { [weak self] indexPath, image in
            guard let self = self else { return }
            
            // Проверяем, видна ли ячейка сейчас, чтобы не делать лишнюю работ
            DispatchQueue.main.async {
                if self.collectionView.indexPathsForVisibleItems.contains(indexPath) {
                    self.collectionView.reloadItems(at: [indexPath])
                }
            }
        }
        
        viewModel.onSuccess = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                let successVC = SuccessfulPaymentVC()
                successVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(successVC, animated: true)
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            guard let self else { return }
            
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                
                let alertTitle = NSLocalizedString("Payment Failed", comment: "")
                let retryTitle = NSLocalizedString("Retry", comment: "")
                let cancelTitle = NSLocalizedString("Cancel", comment: "")
                
                let alert = UIAlertController(
                    title: alertTitle,
                    message: errorMessage,
                    preferredStyle: .alert
                )
                
                let retryAction = UIAlertAction(title: retryTitle, style: .default) { _ in
                    ProgressHUD.show()
                    self.viewModel.pay()
                }
                
                alert.addAction(retryAction)
                let backAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(backAction)
                
                self.present(alert, animated: true)
            }
        }
    }
    
    // MARK: - Private Methods Actions
    
    @objc private func payButtonTapped() {
        ProgressHUD.show()
        viewModel.pay()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Methods UI
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: backgroundPayment.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTerms() {
        let fullText = NSLocalizedString("PaymentVC.UserAgreementTerms", comment: "")
        let highlightText = NSLocalizedString("PaymentVC.UserAgreement", comment: "")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 18
        paragraphStyle.maximumLineHeight = 18
        
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .kern: -0.08,
                .font: UIFont.caption2,
                .foregroundColor: UIColor.textPrimary
            ]
        )
        
        let range = (fullText as NSString).range(of: highlightText)
        if range.location != NSNotFound {
            let url = URL(string: terms)!
            attributedString.addAttribute(.link, value: url, range: range)
        }
        userTermsTextView.attributedText = attributedString
        userTermsTextView.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        
        userTermsTextView.delegate = self
    }
    
    private func setupUI() {
        view.addSubview(backgroundPayment)
        view.addSubview(payButton)
        view.addSubview(userTermsTextView)
        
        [backgroundPayment, payButton, userTermsTextView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundPayment.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundPayment.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundPayment.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundPayment.heightAnchor.constraint(equalToConstant: 186),
            
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 60),
            
            userTermsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userTermsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userTermsTextView.topAnchor.constraint(equalTo: backgroundPayment.topAnchor, constant: 10),
            userTermsTextView.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: 16)
        ])
    }
    
    private func setupNavBar() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: NavigationIcon.back.rawValue),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        backButton.tintColor = UIColor.segmentActive
        navigationItem.leftBarButtonItem = backButton
        
        let title = UILabel()
        title.text = NSLocalizedString("PaymentVC.choose a payment methods", comment: "")
        title.font = .bodyBold
        title.textColor = .segmentActive
        title.textAlignment = .center
        navigationItem.titleView = title
    }

}


// MARK: - UICollectionViewDataSource

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < viewModel.items.count else {
            // Защита от рассинхронизации данных и UI
            return UICollectionViewCell()
        }
        
        let cell: PaymentCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let item = viewModel.items[indexPath.item]
        
        cell.configureText(with: item)
        if let image = viewModel.image(for: indexPath) {
            cell.setImage(with: image)
        } else {
            //Если картинки нет (ещё грузится или нет вообще) - ставим системный плейсхолдер
            guard let placeholder = UIImage(systemName: "circle") else { return cell}
            cell.setImage(with: placeholder)
            
        }
        
        return cell
    }
    
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 7
        let cell: CGFloat = 2
        let totalSpacing = spacing * (cell - 1)
        let availableWidth = collectionView.frame.width - totalSpacing
        let widthPerItem = availableWidth / cell
        return CGSize(width: widthPerItem, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectItem(at: indexPath)
    }
}

// MARK: - UITextViewDelegate

extension PaymentViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange) -> Bool {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        return false
    }
}
