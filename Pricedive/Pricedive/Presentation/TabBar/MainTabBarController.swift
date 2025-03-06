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

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupViewControllers() {
        let homeViewModel = HomeViewModel()
        let myPageViewModel = MyPageViewModel(homeViewModel: homeViewModel)

        let categoryController = UINavigationController(rootViewController: CategoryViewController(viewModel: CategoryViewModel()))
        let homeViewController = UINavigationController(rootViewController: HomeViewController(viewModel: homeViewModel))
        let likeViewController = UINavigationController(rootViewController: LikeViewController(viewModel: homeViewModel))
        let myPageViewController = UINavigationController(rootViewController: MyPageViewController(viewModel: myPageViewModel))

        categoryController.tabBarItem = UITabBarItem(title: "Category", image: UIImage(systemName: "line.3.horizontal"), tag: 0)
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        likeViewController.tabBarItem = UITabBarItem(title: "Like", image: UIImage(systemName: "heart"), tag: 2)
        myPageViewController.tabBarItem = UITabBarItem(title: "MyPage", image: UIImage(systemName: "person.crop.circle"), tag: 3)

        viewControllers = [categoryController, homeViewController, likeViewController, myPageViewController]
        selectedIndex = 1

        homeViewModel.loadEvents()
    }
    
    private func createViewController(_ controller: UIViewController, title: String, image: String, tag: Int) -> UIViewController {
        controller.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: image), tag: tag)
        return controller
    }
}
