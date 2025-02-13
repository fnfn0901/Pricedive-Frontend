//
//  EventDetailViewController.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit
import SafariServices
import Combine

class EventDetailViewController: UIViewController {
    private let viewModel: EventDetailViewModel
    private let detailView = EventDetailView()
    private var cancellables = Set<AnyCancellable>()
    private let eventId: Int

    init(eventId: Int, homeViewModel: HomeViewModel) {
        self.eventId = eventId
        self.viewModel = EventDetailViewModel(eventId: eventId, homeViewModel: homeViewModel)
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
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupActions()
        viewModel.fetchVideoDetail(videoId: eventId)
    }

    private func setupBindings() {
        viewModel.$videoDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] video in
                guard let self = self, let video = video else { return }
                self.detailView.updateVideoView(with: video)
            }
            .store(in: &cancellables)
    }

    private func setupActions() {
        detailView.backIconButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        detailView.goToButton.addTarget(self, action: #selector(didTapGoToButton), for: .touchUpInside)
        detailView.heartButton.addTarget(self, action: #selector(didTapHeartButton), for: .touchUpInside)
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapGoToButton() {
        guard let videoLink = viewModel.videoDetail?.urlLink, let url = URL(string: videoLink) else {
            let alert = UIAlertController(title: "Error", message: "올바른 URL이 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }

        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }

    @objc private func didTapHeartButton() {
        viewModel.toggleLikeStatus()
        detailView.updateHeartButton(isLiked: viewModel.isLiked)
    }
}
