//
//  BaseView.swift
//  Pricedive
//
//  Created by 신호연 on 12/13/24.
//

import UIKit
import SnapKit

class BaseView: UIView {

    let scrollView = UIScrollView()
    let contentView = UIView()
    let categoryFilterView = CategoryFilterView()
    let collectionView: UICollectionView

    var viewModel: CategoryViewModel? {
        didSet {
            if let viewModel = viewModel {
                categoryFilterView.bind(to: viewModel)
            }
        }
    }

    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupCollectionViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(categoryFilterView, collectionView)
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        categoryFilterView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryFilterView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
    }

    private func setupCollectionViewLayout() {
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
