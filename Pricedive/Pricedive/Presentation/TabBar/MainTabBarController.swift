//
//  MainTabBarController.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupTabBarAppearance()
        setupViewControllers()
    }
    
    // MARK: - TabBar Appearance 설정
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        let selectedColor = UIColor.mainBlue
        let normalColor = UIColor(hex: "5F6368")!
        
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]
        appearance.stackedLayoutAppearance.normal.iconColor = normalColor
        
        let topBorder = UIView()
        topBorder.backgroundColor = .mainWhite
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.bounds.width, height: 1)
        tabBar.addSubview(topBorder)

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    // MARK: - View Controllers 설정
    private func setupViewControllers() {
        let userId = 1
        let homeViewModel = HomeViewModel(userId: userId)

        let categoryController = createViewController(CategoryViewController(viewModel: CategoryViewModel()), title: "Category", image: "line.3.horizontal", tag: 0)
        let homeViewController = createViewController(UINavigationController(rootViewController: HomeViewController(viewModel: homeViewModel)), title: "Home", image: "house", tag: 1)
        let likeViewController = createViewController(LikeViewController(viewModel: homeViewModel), title: "Like", image: "heart", tag: 2)
        let myPageViewController = createViewController(
            UINavigationController(rootViewController: MyPageViewController(viewModel: homeViewModel)),
            title: "MyPage",
            image: "person.crop.circle",
            tag: 3
        )

        viewControllers = [categoryController, homeViewController, likeViewController, myPageViewController]
        selectedIndex = 1

        homeViewModel.loadEvents()
    }
    
    private func createViewController(_ controller: UIViewController, title: String, image: String, tag: Int) -> UIViewController {
        controller.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: image), tag: tag)
        return controller
    }
    
    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view,
              let toView = viewController.view,
              fromView != toView else {
            return true
        }
        
        UIView.transition(from: fromView, to: toView, duration: 0, options: .transitionCrossDissolve, completion: nil)
        return true
    }
}
