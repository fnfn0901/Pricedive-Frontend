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
        homeView.collectionView.dataSource = self
        homeView.reloadCollectionView()
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.titleText.bind { [weak self] text in
            guard let self = self else { return }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventProductCell", for: indexPath) as? EventCell else {
            return UICollectionViewCell()
        }
        
        // 목데이터 설정
        let title = "아토덤 인텐시브밤 200ml + 울트라 크림 추가 증정"
        let imageUrl = "https://m-goods.sivillage.com/goods/getGoodDescCont.siv?goods_no=2303705383/proxy/src/http://www.bioderma.co.kr/img/detail/Ato_UCR_img3.jpg/dims/optimize"
        let profileImageUrl = "https://yt3.googleusercontent.com/Oh7Fb_JBhkVUB1y0671PeYNSYJbxouMd6DEQzcN9JHaVDgp5b4DlKfRt0ehW53Ol7UxMD0xkJts=s900-c-k-c0x00ffffff-no-rj"
        let dDayText = "3"
        
        cell.configureCell(title: title, imageUrl: imageUrl, profileImageUrl: profileImageUrl, dDayText: dDayText)
        
        return cell
    }
}
