//
//  SearchViewController.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import Combine

class SearchViewController: UIViewController, UICollectionViewDataSource {
    private let searchView = SearchView()
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
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.collectionView.dataSource = self
        setupBindings()
    }

    private func setupBindings() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: searchView.searchTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .assign(to: \.searchQuery, on: viewModel)
            .store(in: &cancellables)

        viewModel.events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.searchView.reloadCollectionView()
            }
            .store(in: &cancellables)
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.events.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventProductCell", for: indexPath) as? EventCell else {
            return UICollectionViewCell()
        }

        let event = viewModel.events.value[indexPath.row]
        cell.configureCell(
            title: event.eventTitle,
            imageUrl: event.eventImage ?? "",
            profileImageUrl: event.youtuberProfileImage,
            dDayText: "3"
        )
        return cell
    }
}
