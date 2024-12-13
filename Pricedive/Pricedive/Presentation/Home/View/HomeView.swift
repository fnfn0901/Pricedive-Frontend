//
//  HomeView.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import SnapKit

class HomeView: UIView {

    let topFixedFrame = TopFixedFrameView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let categoryFilterView = CategoryFilterView()
    let carouselView = CarouselView()
    let collectionView: UICollectionView

    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20 // 행 간의 간격
        layout.minimumInteritemSpacing = 20 // 열 간의 간격

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20 // 행 간의 간격
        layout.minimumInteritemSpacing = 20 // 열 간의 간격

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        setupTopFixedFrame()
        setupScrollView()
        setupContentView()
        setupCollectionView()
    }

    private func setupTopFixedFrame() {
        addSubview(topFixedFrame)
        topFixedFrame.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
    }

    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(topFixedFrame.snp.bottom).offset(17)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    private func setupContentView() {
        contentView.addSubview(categoryFilterView)
        categoryFilterView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }

        contentView.addSubview(carouselView)
        carouselView.snp.makeConstraints { make in
            make.top.equalTo(categoryFilterView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }

        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(carouselView.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: "EventProductCell")
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let screenWidth = UIScreen.main.bounds.width
            let cellSpacing: CGFloat = 20
            let sectionInset: CGFloat = 20
            let totalSpacing = cellSpacing + (sectionInset * 2)
            let cellWidth = (screenWidth - totalSpacing) / 2
            
            let imageViewHeight = cellWidth * 0.75
            let cellHeight = imageViewHeight * 1.25
            
            layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
            layout.minimumLineSpacing = 20
            layout.minimumInteritemSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
        }
    }

    func updateCollectionViewHeight() {
        collectionView.layoutIfNeeded()
        let contentHeight = collectionView.contentSize.height + 20

        guard contentHeight > 0 else { return }

        collectionView.snp.updateConstraints { make in
            make.height.equalTo(contentHeight)
        }
        contentView.layoutIfNeeded()
    }

    func reloadCollectionView() {
        collectionView.reloadData()
        DispatchQueue.main.async { [weak self] in
            self?.updateCollectionViewHeight()
        }
    }
}
