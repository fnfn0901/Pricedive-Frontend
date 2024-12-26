//
//  LikeViewController.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit
import Combine
import SnapKit

final class LikeViewController: UIViewController {
    private let likeView = LikeView()
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        self.view = likeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupActions()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        likeView.tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        likeView.tableView.setContentOffset(CGPoint(x: 0, y: -12), animated: false)
    }

    // MARK: - Setup Methods
    private func setupTableView() {
        likeView.tableView.delegate = self
        likeView.tableView.dataSource = self
        likeView.tableView.separatorStyle = .none
        likeView.tableView.showsVerticalScrollIndicator = false
        likeView.tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }

    private func setupActions() {
        likeView.savedItemsLabel.isUserInteractionEnabled = true
        likeView.inProgressLabel.isUserInteractionEnabled = true

        let savedTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSavedItems))
        likeView.savedItemsLabel.addGestureRecognizer(savedTapGesture)

        let inProgressTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapInProgress))
        likeView.inProgressLabel.addGestureRecognizer(inProgressTapGesture)
    }

    private func bindViewModel() {
        viewModel.$events
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.likeView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions
    @objc private func didTapSavedItems() {
        likeView.animateBlueBox(to: 0)
        // 필요한 경우 ViewModel 업데이트 로직 추가
    }

    @objc private func didTapInProgress() {
        likeView.animateBlueBox(to: 1)
        // 필요한 경우 ViewModel 업데이트 로직 추가
    }
}

// MARK: - UITableViewDataSource
extension LikeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.events.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LikeProductCell", for: indexPath) as? LikeProductCell else {
            return UITableViewCell()
        }
        let event = viewModel.events[indexPath.section]
        cell.configure(with: event)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LikeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
