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
    
    // MARK: - TabBar Appearance
    private func setupTabBarAppearance() {
        addTopBorderToTabBar()
        
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
    
    private func addTopBorderToTabBar() {
        let topBorder = CALayer()
        topBorder.backgroundColor = UIColor.mainWhite.cgColor
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.bounds.width, height: 1)
        tabBar.layer.addSublayer(topBorder)
    }
    
    // MARK: - View Controllers Setup
    private func setupViewControllers() {
        let sharedViewModel = HomeViewModel(events: createSampleEvents())
        let myPageViewModel = MyPageViewModel(events: createSampleEvents())
        
        let categoryController = createViewController(SearchViewController(viewModel: sharedViewModel), title: "Category", image: "line.3.horizontal", tag: 0)
        let homeViewController = createViewController(UINavigationController(rootViewController: HomeViewController(viewModel: sharedViewModel)), title: "Home", image: "house", tag: 1)
        let searchViewController = createViewController(CategoryViewController(), title: "Search", image: "magnifyingglass", tag: 2)
        let myPageViewController = createViewController(MyPageViewController(viewModel: myPageViewModel), title: "MyPage", image: "person.crop.circle", tag: 3)
        
        viewControllers = [categoryController, homeViewController, searchViewController, myPageViewController]
        selectedIndex = 1
    }
    
    private func createViewController(_ controller: UIViewController, title: String, image: String, tag: Int) -> UIViewController {
        controller.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: image), tag: tag)
        return controller
    }
    
    private func createSampleEvents() -> [Event] {
        return (1...20).map { index in
            Event(
                eventId: index,
                eventLink: "https://www.youtube.com/watch?v=Kg7_J70MANo",
                eventImage: "https://m-goods.sivillage.com/goods/getGoodDescCont.siv?goods_no=2303705383/proxy/src/http://www.bioderma.co.kr/img/detail/Ato_UCR_img3.jpg/dims/optimize",
                youtuberProfileImage: "https://yt3.googleusercontent.com/Oh7Fb_JBhkVUB1y0671PeYNSYJbxouMd6DEQzcN9JHaVDgp5b4DlKfRt0ehW53Ol7UxMD0xkJts=s900-c-k-c0x00ffffff-no-rj",
                eventEndDate: DateComponents(calendar: Calendar.current, year: 2024, month: 12, day: 31).date!,
                eventTitle: "Sample Event \(index)",
                eventDescription: """
🤍 구독자 댓글 이벤트 요약 🤍

    •    참여기간: 10월 28일(월) ~ 11월 3일(일)
    •    참여방법:
영상에서 소개된 ‘칸디데 미백 치약’의 기대평 또는 사용해 보고 싶은 이유를 댓글로 작성
    •    당첨선물:
    •    칸디데 미백 치약: 3명
    •    던스트 맨투맨(S사이즈): 1명 (직접 구매)
    •    당첨자 발표: 11월 4일(월) 오후 9시, 댓글 상단 고정 💌

🦷 칸디데 미백 치약 판매 링크:
정가 15,000 → 13% 할인: 13,000원
할인 기간: 10월 28일 ~ 11월 3일
""",
                isLiked: false
            )
        }
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
