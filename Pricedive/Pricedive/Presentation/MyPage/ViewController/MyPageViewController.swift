//
//  MyPageViewController.swift
//  Pricedive
//
//  Created by 신호연 on 12/26/24.
//

import UIKit
import Combine

class MyPageViewController: UIViewController {
    private let myPageView = MyPageView()
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
        view = myPageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        bindViewModel()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }

    private func bindViewModel() {
        viewModel.$events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] events in
                // 추후에 MyPageView에 데이터를 반영하는 로직 추가
            }
            .store(in: &cancellables)
    }
}
