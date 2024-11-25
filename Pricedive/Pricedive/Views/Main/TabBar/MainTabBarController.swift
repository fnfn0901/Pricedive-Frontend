//
//  MainTabBarController.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarAppearance()
        setupViewControllers()
    }

    private func setupTabBarAppearance() {
        let topBorder = CALayer()
        topBorder.backgroundColor = UIColor.mainWhite.cgColor
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.bounds.width, height: 1)
        tabBar.layer.addSublayer(topBorder)

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.mainBlue]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.mainBlue

        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(hex: "5F6368")!]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(hex: "5F6368")!

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }

    private func setupViewControllers() {
        let categoryController = CategoryViewController()
        let homeViewController = MainViewController()
        let searchViewController = SearchViewController()
        let myPageViewController = MyPageViewController()

        categoryController.tabBarItem = UITabBarItem(title: "Category", image: UIImage(systemName: "line.3.horizontal"), tag: 0)
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        myPageViewController.tabBarItem = UITabBarItem(title: "MyPage", image: UIImage(systemName: "person.crop.circle"), tag: 3)

        viewControllers = [categoryController, homeViewController, searchViewController, myPageViewController]
    }
}
