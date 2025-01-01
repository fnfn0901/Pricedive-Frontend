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
        populateSections(with: createSampleViewedProducts())
        setupClearAllAction()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }

    private func bindViewModel() {
        // 필요 시 ViewModel 바인딩 로직 추가
    }

    private func populateSections(with viewedProducts: [ViewedProduct]) {
        let groupedProducts = groupProductsByDate(viewedProducts)

        groupedProducts.forEach { (title, products) in
            let cells = products.map { product -> UIView in
                let cell = LikeProductCell()
                cell.configure(with: product.toEvent(), style: .myPage)
                return cell
            }
            myPageView.addSection(title: title, cells: cells)
        }
    }

    private func groupProductsByDate(_ products: [ViewedProduct]) -> [(String, [ViewedProduct])] {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!

        var todayProducts = [ViewedProduct]()
        var yesterdayProducts = [ViewedProduct]()
        var thisWeekProducts = [ViewedProduct]()

        products.forEach { product in
            if calendar.isDate(product.viewedDate, inSameDayAs: today) {
                todayProducts.append(product)
            } else if calendar.isDate(product.viewedDate, inSameDayAs: yesterday) {
                yesterdayProducts.append(product)
            } else if product.viewedDate >= startOfWeek {
                thisWeekProducts.append(product)
            }
        }

        return [
            ("오늘", todayProducts),
            ("어제", yesterdayProducts),
            ("이번 주", thisWeekProducts)
        ].filter { !$0.1.isEmpty }
    }

    private func setupClearAllAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleClearAllTapped))
        myPageView.clearAllLabel.addGestureRecognizer(tapGesture)
    }

    @objc private func handleClearAllTapped() {
        myPageView.contentView.subviews.forEach { $0.removeFromSuperview() }
    }

    private func createSampleViewedProducts() -> [ViewedProduct] {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let earlierThisWeek = calendar.date(byAdding: .day, value: -3, to: today)!

        return [
            ViewedProduct(id: 1, title: "오늘 본 상품 1", imageUrl: "https://via.placeholder.com/150", viewedDate: today),
            ViewedProduct(id: 2, title: "오늘 본 상품 2", imageUrl: "https://via.placeholder.com/150", viewedDate: today),
            ViewedProduct(id: 3, title: "어제 본 상품 1", imageUrl: "https://via.placeholder.com/150", viewedDate: yesterday),
            ViewedProduct(id: 4, title: "이번 주 본 상품 1", imageUrl: "https://via.placeholder.com/150", viewedDate: earlierThisWeek)
        ]
    }
}
