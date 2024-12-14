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
    private let viewModel: HomeViewModel
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
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.collectionView.dataSource = self
        homeView.collectionView.delegate = self
        homeView.collectionView.register(EventCell.self, forCellWithReuseIdentifier: "EventProductCell")
        setupBindings()

        homeView.carouselView.imageUrls = [
            "https://cdn.011st.com/11dims/resize/1240x400/quality/100/11src/browsing/space/banner/2024/12/10/2412101132499001264_10.jpg",
            "https://cdn.011st.com/11dims/resize/1240x400/quality/100/11src/browsing/space/banner/2024/12/5/2412051442589701186_720.jpg",
            "https://cdn.011st.com/11dims/resize/1240x400/quality/100/11src/browsing/space/banner/2024/12/10/2412101509211100954_27.png",
            "https://cdn.011st.com/11dims/resize/1240x400/quality/100/11src/browsing/space/banner/2024/12/4/2412041454203801216_690.jpg",
            "https://cdn.011st.com/11dims/resize/1240x400/quality/100/11src/browsing/space/banner/2024/12/10/2412101141100201264_8.jpg"
        ]

        homeView.reloadCollectionView()
    }

    private func setupBindings() {
        viewModel.$events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.homeView.reloadCollectionView()
            }
            .store(in: &cancellables)
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventProductCell", for: indexPath) as? EventCell else {
            return UICollectionViewCell()
        }

        let event = viewModel.events[indexPath.row]
        cell.configureCell(event: event, viewModel: viewModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = viewModel.events[indexPath.row]
        let detailViewModel = EventDetailViewModel(eventId: event.eventId, homeViewModel: viewModel)
        let detailViewController = EventDetailViewController(viewModel: detailViewModel, homeViewModel: viewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
