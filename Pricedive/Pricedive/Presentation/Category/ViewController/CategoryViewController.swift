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
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
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
                
                self?.categoryView.setCategorySelectionHandler { category in
                    self?.categorySelected(category)
                }
            }
            .store(in: &cancellables)
    }
    
    private func categorySelected(_ category: Category) {
        guard let tabBarController = self.tabBarController as? MainTabBarController else { return }

        tabBarController.selectedIndex = 1

        if let homeNavController = tabBarController.viewControllers?[1] as? UINavigationController,
           let homeViewController = homeNavController.viewControllers.first as? HomeViewController {
            homeViewController.viewModel.searchEvents(category: category.name, query: "")
            homeViewController.homeView.categoryFilterView.selectCategory(category.name)
        }
    }
}
