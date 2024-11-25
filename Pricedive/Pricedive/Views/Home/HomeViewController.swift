//
//  HomeViewController.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private let viewModel = HomeViewModel()

    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.titleText.bind { [weak self] text in
            
        }
    }
}
