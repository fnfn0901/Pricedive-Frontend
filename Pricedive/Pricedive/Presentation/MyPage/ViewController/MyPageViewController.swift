//
//  MyPageViewController.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

class MyPageViewController: UIViewController {
    private let myPageView = MyPageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActions()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = myPageView
    }
    
    private func setupActions() {
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(didTapSavedItems))
        myPageView.savedItemsLabel.isUserInteractionEnabled = true
        myPageView.savedItemsLabel.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(didTapInProgress))
        myPageView.inProgressLabel.isUserInteractionEnabled = true
        myPageView.inProgressLabel.addGestureRecognizer(tapGesture2)
    }
    
    @objc private func didTapSavedItems() {
        myPageView.animateBlueBox(to: 0)
    }
    
    @objc private func didTapInProgress() {
        myPageView.animateBlueBox(to: 1)
    }
}
