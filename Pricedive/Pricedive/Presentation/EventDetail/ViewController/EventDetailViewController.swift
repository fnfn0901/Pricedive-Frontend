//
//  EventDetailViewController.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit

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
        view = detailView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupBindings()
        setupActions()
        updateView() // 데이터 업데이트
    }

    private func setupBindings() {
        // 데이터 바인딩 로직 추가 가능
    }

    private func setupActions() {
        detailView.backIconButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        detailView.searchIconButton.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
    }

    private func updateView() {
        detailView.configureCell(
            title: viewModel.eventTitle,
            imageUrl: viewModel.eventImageURL?.absoluteString ?? "",
            profileImageUrl: viewModel.youtuberProfileImageURL?.absoluteString ?? "",
            dDayText: viewModel.dDayText
        )
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapSearch() {
        let searchViewController = SearchViewController(viewModel: homeViewModel)
        navigationController?.pushViewController(searchViewController, animated: true)
    }
}
