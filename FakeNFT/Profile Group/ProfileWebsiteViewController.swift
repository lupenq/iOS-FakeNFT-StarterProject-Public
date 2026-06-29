//
//  ProfileWebsiteViewController.swift
//  FakeNFT
//
//  Created by Данил Третьяченко on 29.06.2026.
//

import UIKit
import WebKit

final class ProfileWebsiteViewController: UIViewController {
    
    // MARK: - Properties
    private let url: URL
    
    // MARK: - UI Elements
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .systemBackground
        webView.isOpaque = false // Защита от белых вспышек при загрузке в темной теме
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = UIColor.label
        indicator.hidesWhenStopped = true // Автоматически прячется, когда не крутится
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Initialization
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupNavigationBar()
        
        webView.navigationDelegate = self
        
        // Загружаем сайт
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(webView)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        // Делаем кнопку назад просто стрелочкой без текста "Профиль"
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = UIColor.label
    }
}

// MARK: - WKNavigationDelegate
extension ProfileWebsiteViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
