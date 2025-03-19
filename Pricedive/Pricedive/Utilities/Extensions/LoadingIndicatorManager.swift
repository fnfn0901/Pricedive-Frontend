//
//  LoadingIndicatorManager.swift
//  Pricedive
//
//  Created by 신호연 on 3/19/25.
//

import UIKit

class LoadingIndicatorManager {
    static let shared = LoadingIndicatorManager()
    private var spinner: UIActivityIndicatorView?

    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showLoading),
            name: .showLoading,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideLoading),
            name: .hideLoading,
            object: nil
        )
    }

    @objc private func showLoading() {
        guard let window = UIApplication.shared.windows.first else { return }
        if spinner == nil {
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.color = .black
            spinner.center = window.center
            spinner.hidesWhenStopped = true
            window.addSubview(spinner)
            self.spinner = spinner
        }
        spinner?.startAnimating()
    }

    @objc private func hideLoading() {
        spinner?.stopAnimating()
    }
}

extension Notification.Name {
    static let showLoading = Notification.Name("ShowLoading")
    static let hideLoading = Notification.Name("HideLoading")
}
