//
//  SearchViewController.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    private let viewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.collectionView.dataSource = self
        setupBindings()
    }
    
    private func setupBindings() {
        // 검색어 입력을 viewModel의 searchQuery에 바인딩
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: searchView.searchTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .assign(to: \.searchQuery, on: viewModel)
            .store(in: &cancellables)

        // 검색 결과를 반영
        viewModel.filteredEvents
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.searchView.reloadCollectionView()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredEvents.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventProductCell", for: indexPath) as? EventCell else {
            return UICollectionViewCell()
        }
        
        let event = viewModel.filteredEvents.value[indexPath.row]
        cell.configureCell(
            title: event.eventTitle,
            imageUrl: event.eventDescription ?? "",
            profileImageUrl: event.youtuberProfileImage,
            dDayText: "3"
        )
        
        return cell
    }
}
