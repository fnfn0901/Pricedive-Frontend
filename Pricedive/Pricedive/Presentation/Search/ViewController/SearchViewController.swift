//
//  SearchViewController.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import Combine

class SearchViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties
    private let searchView = SearchView()
    private let viewModel: HomeViewModel
    private var categoryViewModel = CategoryViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializers
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = searchView
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
        
        searchView.viewModel = categoryViewModel
        configureCollectionView()
        setupBindings()
        setupSearchBar()
    }

    // MARK: - Setup Methods
    private func configureCollectionView() {
        searchView.collectionView.dataSource = self
        searchView.collectionView.register(EventCell.self, forCellWithReuseIdentifier: "EventProductCell")
    }

    private func setupBindings() {
        // Search query binding using Combine
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: searchView.searchBarView.searchTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .removeDuplicates()
            .assign(to: \.searchQuery, on: viewModel)
            .store(in: &cancellables)

        // Events binding
        viewModel.$events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.searchView.reloadCollectionView()
            }
            .store(in: &cancellables)
    }

    private func setupSearchBar() {
        searchView.searchBarView.searchTextField.delegate = self
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Enter 키를 눌렀을 때 키보드 숨기기
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // 텍스트 입력이 완료되었을 때 추가 로직 처리 가능
        guard let text = textField.text else { return }
        print("User finished typing: \(text)")
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // Clear 버튼을 눌렀을 때 뷰 모델의 검색 쿼리 초기화
        viewModel.searchQuery = ""
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {

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
}
