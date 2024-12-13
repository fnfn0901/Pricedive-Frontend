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
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 160, height: 173)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 160, height: 173)

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
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1000)
        }
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: "EventProductCell")
    }

    func updateCollectionViewHeight() {
        collectionView.layoutIfNeeded()
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(collectionView.contentSize.height)
        }
        contentView.layoutIfNeeded()
    }

    func reloadCollectionView() {
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        updateCollectionViewHeight()
    }
}
