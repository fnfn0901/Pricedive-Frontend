//
//  SplashViewController.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import Combine

class SplashViewController: UIViewController {

    private var splashView = SplashView()
    private var viewModel: SplashViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = splashView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.startSplashTimer()
    }

    private func bindViewModel() {
        viewModel.$isSplashCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isCompleted in
                guard isCompleted else { return }
                self?.navigateToNextScreen()
            }
            .store(in: &cancellables)
    }

    private func navigateToNextScreen(
        transitionStyle: UIModalTransitionStyle = .crossDissolve,
        presentationStyle: UIModalPresentationStyle = .fullScreen
    ) {
        let nextViewController = MainTabBarController()
        nextViewController.modalTransitionStyle = transitionStyle
        nextViewController.modalPresentationStyle = presentationStyle
        present(nextViewController, animated: true)
    }
}
