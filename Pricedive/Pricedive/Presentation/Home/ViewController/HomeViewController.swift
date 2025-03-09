//
//  HomeViewController.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    private let homeView = HomeView()
    let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = homeView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView.viewModel = viewModel

        homeView.searchBarView.onSearch = { [weak self] query in
            self?.viewModel.searchEvents(category: self?.viewModel.selectedCategory, query: query)
        }

        homeView.searchBarView.onResetSearch = { [weak self] in
            self?.viewModel.resetFilters()
        }

        homeView.categoryFilterView.onCategorySelected = { [weak self] category in
            if category == nil {
                self?.viewModel.resetFilters()
            } else {
                self?.viewModel.searchEvents(category: category, query: self?.viewModel.searchQuery ?? "")
            }
        }

        homeView.collectionView.dataSource = self
        homeView.collectionView.delegate = self
        homeView.collectionView.register(EventCell.self, forCellWithReuseIdentifier: "EventProductCell")

        homeView.carouselView.imageUrls = [
            "https://cdn.011st.com/11dims/resize/1240x400/quality/100/11src/browsing/space/banner/2024/12/10/2412101132499001264_10.jpg",
            "https://cdn.011st.com/11dims/resize/1240x400/quality/100/11src/browsing/space/banner/2024/12/5/2412051442589701186_720.jpg",
            "https://cdn.011st.com/11dims/resize/1240x400/quality/100/11src/browsing/space/banner/2024/12/10/2412101509211100954_27.png",
            "https://cdn.011st.com/11dims/resize/1240x400/quality/100/11src/browsing/space/banner/2024/12/4/2412041454203801216_690.jpg",
            "https://cdn.011st.com/11dims/resize/1240x400/quality/100/11src/browsing/space/banner/2024/12/10/2412101141100201264_8.jpg"
        ]

        setupBindings()
        DispatchQueue.main.async {
            self.viewModel.loadEvents()
        }
    }

    private func setupBindings() {
        viewModel.$events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] events in
                guard let self = self else { return }
                
                if events.isEmpty {
                    print("⚠️ [UI] UI 업데이트 실패: 이벤트 리스트가 비어 있음")
                }
                
                self.homeView.collectionView.isHidden = events.isEmpty

                DispatchQueue.main.async {
                    self.homeView.collectionView.reloadData()
                    self.homeView.updateCollectionViewHeight()
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.row < viewModel.events.count,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventProductCell", for: indexPath) as? EventCell else {
            return UICollectionViewCell()
        }

        let event = viewModel.events[indexPath.row]
        cell.configureCell(event: event, viewModel: viewModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.events.count else {
            print("❌ Error: Index out of bounds")
            return
        }

        let selectedEvent = viewModel.events[indexPath.row]

        guard let videoId = selectedEvent.videoId else {
            print("❌ Error: 선택한 이벤트에 비디오 ID가 없습니다.")
            return
        }

        print("✅ 선택된 비디오 ID: \(videoId)")

        let detailViewController = EventDetailViewController(
            event: selectedEvent,
            homeViewModel: viewModel
        )
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    @objc private func handleHeartButtonTap(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? EventCell, let videoId = cell.videoId else {
            print("❌ Error: Unable to identify cell or video ID")
            return
        }

        print("🔍 좋아요 요청 전송 - videoId: \(videoId)")

        viewModel.toggleLike(for: videoId)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            cell.updateHeartButton(isLiked: self.viewModel.isLiked(for: videoId))
        }
    }
}
