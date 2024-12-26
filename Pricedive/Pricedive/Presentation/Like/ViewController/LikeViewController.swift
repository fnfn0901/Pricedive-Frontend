//
//  LikeViewController.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit
import SnapKit

final class LikeViewController: UIViewController {
    private let likeView = LikeView()
    private let viewModel: LikeViewModel

    // MARK: - Initializer
    init(viewModel: LikeViewModel) {
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
        setupSearchBarActions()
    }

    // MARK: - Setup Methods
    private func setupTableView() {
        likeView.tableView.delegate = self
        likeView.tableView.dataSource = self
        likeView.tableView.separatorStyle = .none
        likeView.tableView.showsVerticalScrollIndicator = false
        likeView.tableView.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 0, right: 0)
    }

    private func setupActions() {
        likeView.savedItemsLabel.isUserInteractionEnabled = true
        likeView.inProgressLabel.isUserInteractionEnabled = true

        let savedTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSavedItems))
        likeView.savedItemsLabel.addGestureRecognizer(savedTapGesture)

        let inProgressTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapInProgress))
        likeView.inProgressLabel.addGestureRecognizer(inProgressTapGesture)
    }

    private func setupSearchBarActions() {
        likeView.topFixedFrameView.searchIconButton.addTarget(self, action: #selector(toggleSearchBar), for: .touchUpInside)
        likeView.searchBarView.xMarkButton.addTarget(self, action: #selector(resetToTopFixedFrame), for: .touchUpInside)
    }

    // MARK: - Search Bar Actions
    @objc private func toggleSearchBar() {
        likeView.toggleVisibility(viewToShow: likeView.searchBarView, viewToHide: likeView.topFixedFrameView)
        likeView.searchBarView.searchTextField.becomeFirstResponder()
    }

    @objc private func resetToTopFixedFrame() {
        likeView.searchBarView.searchTextField.text = ""
        likeView.searchBarView.searchTextField.resignFirstResponder()
        likeView.toggleVisibility(viewToShow: likeView.topFixedFrameView, viewToHide: likeView.searchBarView)
    }

    // MARK: - Actions
    @objc private func didTapSavedItems() {
        likeView.animateBlueBox(to: 0)
        // Implement saved items filtering logic if needed
    }

    @objc private func didTapInProgress() {
        likeView.animateBlueBox(to: 1)
        // Implement in-progress filtering logic if needed
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

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
        // Handle row selection if needed
    }
}
