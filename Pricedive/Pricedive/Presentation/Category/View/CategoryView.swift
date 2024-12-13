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
        let label = UILabel()
        label.text = "카테고리"
        label.font = UIFont(name: "Pretendard-Bold", size: 18)
        label.textColor = .mainBlack
        label.textAlignment = .center
        return label
    }()

    private let topView: UIView = {
        let view = UIView()
        return view
    }()
    
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
        bottomView.subviews.forEach { $0.removeFromSuperview() }
        
        for (index, category) in categories.enumerated() {
            let itemView = CategoryItemView()
            let isLast = index == categories.count - 1
            itemView.configure(with: category, isLast: isLast)
            bottomView.addSubview(itemView)
            
            itemView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(50)
                
                if index == 0 {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(bottomView.subviews[index - 1].snp.bottom)
                }
            }
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
            make.height.equalTo(60)
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
