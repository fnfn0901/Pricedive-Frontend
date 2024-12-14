//
//  EventDetailViewController.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit
import SafariServices

class EventDetailViewController: UIViewController {
    private let viewModel: EventDetailViewModel
    private let detailView = EventDetailView()
    private let homeViewModel: HomeViewModel

    init(viewModel: EventDetailViewModel, homeViewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        detailView.eventId = viewModel.eventId
        detailView.viewModel = homeViewModel
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
        let searchViewController = SearchViewController(viewModel: homeViewModel)
        navigationController?.pushViewController(searchViewController, animated: true)
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
