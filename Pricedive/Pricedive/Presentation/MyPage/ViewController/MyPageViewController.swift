//
//  MyPageViewController.swift
//  Pricedive
//
//  Created by 신호연 on 12/26/24.
//

import UIKit
import Combine

class MyPageViewController: UIViewController, MyPageViewDelegate {
    private let myPageView = MyPageView()
    private let viewModel: MyPageViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: MyPageViewModel) {
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
        myPageView.delegate = self
        setupNavigationBar()
        bindViewModel()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }

    private func bindViewModel() {
        viewModel.$groupedProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] groupedProducts in
                self?.updateUI(with: groupedProducts)
            }
            .store(in: &cancellables)
    }

    private func updateUI(with groupedProducts: [(String, [ViewedProduct])]) {
        myPageView.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        groupedProducts.forEach { (title, products) in
            let cells = products.map { product -> UIView in
                let cell = LikeProductCell()
                cell.configure(with: product.toEvent(), viewModel: viewModel.homeViewModel, style: .myPage)
                return cell
            }
            myPageView.addSection(title: title, cells: cells)
        }
    }

    func clearAllButtonTapped() {
        viewModel.clearAllViewedProducts()
        myPageView.contentView.subviews.forEach { $0.removeFromSuperview() }
    }
}
