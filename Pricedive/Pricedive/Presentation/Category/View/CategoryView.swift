//
//  CategoryView.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import SnapKit

protocol CategoryViewDelegate: AnyObject {
    func didTapXButton()
}

class CategoryView: UIView {
    
    weak var delegate: CategoryViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = CustomStyles.navigationText()
        label.text = "카테고리"
        return label
    }()

    private let topView = UIView()
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCategories(_ categories: [Category]) {
        bottomView.clearSubviews()
        
        for (index, category) in categories.enumerated() {
            let itemView = CategoryItemView()
            itemView.configure(with: category, isLast: index == categories.count - 1)
            bottomView.addArrangedSubviewWithSpacing(itemView, index: index)
        }
    }
    
    private func setupViews() {
        addSubview(topView)
        topView.addSubview(titleLabel)
        addSubview(bottomView)
    }
    
    private func setupConstraints() {
        topView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(topView)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
