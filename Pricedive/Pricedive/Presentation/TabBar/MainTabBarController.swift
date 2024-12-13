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
        // ViewModel 생성
        let sampleEvents: [Event] = (1...20).map { index in
            Event(
                eventId: index,
                eventImage: "https://m-goods.sivillage.com/goods/getGoodDescCont.siv?goods_no=2303705383/proxy/src/http://www.bioderma.co.kr/img/detail/Ato_UCR_img3.jpg/dims/optimize",
                youtuberProfileImage: "https://yt3.googleusercontent.com/Oh7Fb_JBhkVUB1y0671PeYNSYJbxouMd6DEQzcN9JHaVDgp5b4DlKfRt0ehW53Ol7UxMD0xkJts=s900-c-k-c0x00ffffff-no-rj",
                eventEndDate: Date(),
                eventTitle: "Sample Event \(index)",
                eventDescription: "Description \(index)",
                isLiked: false
            )
        }
        let sharedViewModel = HomeViewModel(events: sampleEvents)

        // 뷰 컨트롤러 생성
        let categoryController = CategoryViewController()
        let homeViewController = HomeViewController(viewModel: sharedViewModel)
        let searchViewController = SearchViewController(viewModel: sharedViewModel)
        let myPageViewController = MyPageViewController()

        // 탭 바 아이템 설정
        categoryController.tabBarItem = UITabBarItem(title: "Category", image: UIImage(systemName: "line.3.horizontal"), tag: 0)
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        myPageViewController.tabBarItem = UITabBarItem(title: "MyPage", image: UIImage(systemName: "person.crop.circle"), tag: 3)

        // 탭 바 컨트롤러에 뷰 컨트롤러 설정
        viewControllers = [categoryController, homeViewController, searchViewController, myPageViewController]
        
        // 기본 선택된 탭 설정
        selectedIndex = 1
    }
}
