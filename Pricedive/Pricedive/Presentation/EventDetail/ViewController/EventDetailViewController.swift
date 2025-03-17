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
    private let videoId: Int
    private let userId: Int
    private let event: Event
    private let viewedProductRepository = ViewedProductRepository()

    init(event: Event, homeViewModel: HomeViewModel) {
            self.event = event
            self.videoId = event.videoId ?? -1
            self.userId = homeViewModel.userId
            self.viewModel = EventDetailViewModel(event: event, homeViewModel: homeViewModel)
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

        saveViewedProduct()
        
        viewModel.loadLikedEvents()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.detailView.updateHeartButton(isLiked: self.viewModel.isLiked)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.viewModel = viewModel
        setupBindings()
        setupActions()

        viewModel.fetchVideoDetail(videoId: videoId)

        DispatchQueue.main.async {
            self.detailView.updateHeartButton(isLiked: self.viewModel.isLiked)

            if let initialPreviewImg = self.viewModel.previewImg, let url = URL(string: initialPreviewImg) {
                self.detailView.imageView.kf.setImage(with: url)
            }
        }
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func saveViewedProduct() {
        let dateFormatter = ISO8601DateFormatter()
        let viewedDate = dateFormatter.string(from: Date())

        let viewedProduct = ViewedProduct(
            id: event.eventId,
            title: event.eventItem,
            imageUrl: event.eventImage,
            viewedDate: viewedDate,
            eventEndDate: event.eventEndDate,
            videoId: event.videoId
        )

        viewedProductRepository.addOrUpdateViewedProduct(viewedProduct)
    }


    private func setupBindings() {
        viewModel.$videoDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] video in
                guard let self = self, let video = video else { return }
                self.detailView.updateVideoView(with: video)
            }
            .store(in: &cancellables)

        viewModel.$isLiked
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLiked in
                self?.detailView.updateHeartButton(isLiked: isLiked)
            }
            .store(in: &cancellables)

        viewModel.$previewImg
            .receive(on: DispatchQueue.main)
            .sink { [weak self] previewImg in
                guard let self = self, let urlString = previewImg, let url = URL(string: urlString) else { return }
                self.detailView.imageView.kf.setImage(with: url)
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
        guard let videoLink = viewModel.videoDetail?.urlLink else {
            let alert = UIAlertController(title: "Error", message: "올바른 URL이 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }

        if let videoId = extractYouTubeVideoID(from: videoLink),
           let youtubeURL = URL(string: "youtube://\(videoId)"),
           UIApplication.shared.canOpenURL(youtubeURL) {
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        } else if let url = URL(string: videoLink) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
    }

    private func extractYouTubeVideoID(from url: String) -> String? {
        if let url = URL(string: url),
           let host = url.host, host.contains("youtube.com") || host.contains("youtu.be") {

            if host.contains("youtu.be") {
                return url.lastPathComponent
            } else if host.contains("youtube.com") {
                let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
                return queryItems?.first(where: { $0.name == "v" })?.value
            }
        }
        return nil
    }

    @objc private func didTapHeartButton() {
        viewModel.toggleLikeStatus(userId: userId, eventId: event.eventId) { [weak self] isLiked in
            DispatchQueue.main.async {
                self?.detailView.updateHeartButton(isLiked: isLiked)
            }
        }
    }
}

extension EventDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
