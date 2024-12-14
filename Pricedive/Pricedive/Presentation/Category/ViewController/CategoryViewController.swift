//
//  CategoryViewController.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import Combine

class CategoryViewController: UIViewController {
    
    private var categoryView = CategoryView()
    private var viewModel = CategoryViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
    
    private func setupView() {
        view.addSubview(categoryView)
        categoryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.$categories
            .receive(on: RunLoop.main)
            .sink { [weak self] categories in
                self?.categoryView.updateCategories(categories)
            }
            .store(in: &cancellables)
    }
}
