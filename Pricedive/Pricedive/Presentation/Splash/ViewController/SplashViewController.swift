//
//  SplashViewController.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import Combine

class SplashViewController: UIViewController {

    private var splashView: SplashView!
    private var viewModel: SplashViewModel!
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: SplashViewModel) {
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
        viewModel.startSplashTimer()
    }

    private func setupView() {
        splashView = SplashView(frame: self.view.bounds)
        view.addSubview(splashView)
    }

    private func bindViewModel() {
        viewModel.$isSplashCompleted
            .receive(on: RunLoop.main)
            .sink { [weak self] isCompleted in
                if isCompleted {
                    self?.navigateToNextScreen()
                }
            }
            .store(in: &cancellables)
    }

    private func navigateToNextScreen() {
        let nextViewController = MainTabBarController()
        nextViewController.modalTransitionStyle = .crossDissolve
        nextViewController.modalPresentationStyle = .fullScreen
        present(nextViewController, animated: true)
    }
}
