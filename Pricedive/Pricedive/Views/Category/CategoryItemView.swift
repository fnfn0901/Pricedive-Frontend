//
//  CategoryItemView.swift
//  Pricedive
//
//  Created by 신호연 on 12/06/24.
//

import UIKit
import SnapKit

class CategoryItemView: UIView {
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NotoSans-Regular", size: 14)
        label.textColor = .mainBlack
        label.textAlignment = .center
        return label
    }()
    
    private let topBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .mainWhite
        return view
    }()
    
    private let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .mainWhite
        view.isHidden = true // 기본적으로 숨김
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with category: Category, isLast: Bool) {
        categoryLabel.text = category.name
        bottomBorder.isHidden = !isLast // 마지막 요소일 때만 하단 스트로크 표시
    }
    
    private func setupView() {
        addSubview(categoryLabel)
        addSubview(topBorder)
        addSubview(bottomBorder)
        backgroundColor = .white
    }
    
    private func setupConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        topBorder.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        bottomBorder.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
