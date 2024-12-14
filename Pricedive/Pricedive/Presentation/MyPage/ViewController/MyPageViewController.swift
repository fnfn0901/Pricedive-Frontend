//
//  MyPageViewController.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

class MyPageViewController: UIViewController {
    private let myPageView = MyPageView()
    
    // 간단한 초기화 메서드 제공
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = myPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 현재 데이터 바인딩은 없음
    }
}
