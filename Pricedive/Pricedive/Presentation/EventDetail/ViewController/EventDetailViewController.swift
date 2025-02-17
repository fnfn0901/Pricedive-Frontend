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

    init(event: Event, homeViewModel: HomeViewModel) {
        self.videoId = event.videoId ?? -1
        print("✅ 생성된 videoId: \(self.videoId)")
        self.userId = homeViewModel.userId
        self.event = event
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

        viewModel.fetchVideoDetail(videoId: videoId)

        if let url = URL(string: event.eventImage) {
            detailView.imageView.kf.setImage(with: url)
        }
    }

    private func setupBindings() {
        viewModel.$videoDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] video in
                guard let self = self, let video = video else { return }
                self.detailView.updateVideoView(with: video)
            }
            .store(in: &cancellables)

        viewModel.$previewImg
            .receive(on: DispatchQueue.main)
            .sink { [weak self] previewImg in
                guard let self = self else { return }

                if let urlString = previewImg, let url = URL(string: urlString) {
                    print("🔄 previewImg 변경 감지: \(urlString)")
                    DispatchQueue.main.async {
                        self.detailView.imageView.kf.setImage(
                            with: url,
                            placeholder: UIImage(named: "placeholder"),
                            options: [
                                .transition(.fade(0.3)),
                                .cacheOriginalImage
                            ],
                            completionHandler: { result in
                                switch result {
                                case .success(let value):
                                    print("✅ 이미지 로드 성공: \(value.source.url?.absoluteString ?? "")")
                                case .failure(let error):
                                    print("❌ 이미지 로드 실패: \(error.localizedDescription)")
                                }
                            }
                        )
                    }
                } else {
                    print("⚠️ previewImg가 nil이거나 올바르지 않은 URL: \(String(describing: previewImg))")
                }
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
        viewModel.toggleLikeStatus(userId: userId, eventId: event.eventId) { [weak self] isLiked in
            DispatchQueue.main.async {
                self?.detailView.updateHeartButton(isLiked: isLiked)
            }
        }
    }
}
