//
//  EventDetailViewController.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit
import SafariServices

class EventDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    private let viewModel: EventDetailViewModel
    private let detailView = EventDetailView()

    init(viewModel: EventDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        detailView.viewModel = viewModel
        view = detailView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        updateView()
        enableSwipeBackGesture()
    }

    private func enableSwipeBackGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    private func setupActions() {
        detailView.backIconButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        detailView.searchIconButton.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        detailView.goToButton.addTarget(self, action: #selector(didTapGoToButton), for: .touchUpInside)
    }

    private func updateView() {
        detailView.configureCell(
            title: viewModel.eventTitle,
            imageUrl: viewModel.eventImageURL?.absoluteString ?? "",
            profileImageUrl: viewModel.youtuberProfileImageURL?.absoluteString ?? "",
            dDayText: viewModel.dDayText,
            eventDescription: viewModel.eventDescription ?? ""
        )
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapSearch() {
        detailView.navigationBar.isHidden = true
        
        if detailView.searchBarView.superview == nil {
            detailView.addSubview(detailView.searchBarView)
            detailView.searchBarView.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(8)
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(48)
            }
        }
        detailView.searchBarView.isHidden = false
        
        detailView.searchBarView.onCancelTapped = { [weak self] in
            guard let self = self else { return }
            self.detailView.searchBarView.isHidden = true
            self.detailView.navigationBar.isHidden = false
        }
    }

    @objc private func didTapGoToButton() {
        guard let eventLink = viewModel.eventLink, let url = URL(string: eventLink) else {
            let alert = UIAlertController(title: "Error", message: "Invalid link.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
