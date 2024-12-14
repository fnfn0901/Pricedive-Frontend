//
//  MyPageViewController.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

final class MyPageViewController: UIViewController {
    private let myPageView = MyPageView()
    private let viewModel: MyPageViewModel

    // Initializer
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = myPageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupActions()
    }

    // MARK: - Setup Methods
    private func setupTableView() {
        myPageView.tableView.delegate = self
        myPageView.tableView.dataSource = self
        myPageView.tableView.separatorStyle = .none
        myPageView.tableView.showsVerticalScrollIndicator = false
        myPageView.tableView.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 0, right: 0)
    }

    private func setupActions() {
        myPageView.savedItemsLabel.isUserInteractionEnabled = true
        myPageView.inProgressLabel.isUserInteractionEnabled = true

        let savedTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSavedItems))
        myPageView.savedItemsLabel.addGestureRecognizer(savedTapGesture)

        let inProgressTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapInProgress))
        myPageView.inProgressLabel.addGestureRecognizer(inProgressTapGesture)
    }

    @objc private func didTapSavedItems() {
        myPageView.animateBlueBox(to: 0)
        // Implement saved items filtering logic if needed
    }

    @objc private func didTapInProgress() {
        myPageView.animateBlueBox(to: 1)
        // Implement in-progress filtering logic if needed
    }
}

// MARK: - UITableViewDataSource
extension MyPageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.events.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageProductCell", for: indexPath) as? MyPageProductCell else {
            return UITableViewCell()
        }
        let event = viewModel.events[indexPath.section]
        cell.configure(with: event)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyPageViewController: UITableViewDelegate {
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
