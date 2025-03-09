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
        let label = CustomStyles.customLabel(
            text: "",
            color: .mainBlack,
            font: UIFont(name: "NotoSans-Regular", size: 14)!,
            lineHeight: 1.0,
            kern: 0
        )
        label.textAlignment = .center
        return label
    }()
    
    private let topBorder = UIView.createBorderView(color: .mainWhite)
    private let bottomBorder: UIView = {
        let view = UIView.createBorderView(color: .mainWhite)
        view.isHidden = true
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
        bottomBorder.isHidden = !isLast
    }
    
    private func setupView() {
        addSubviews(categoryLabel, topBorder, bottomBorder)
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
    
    func getCategoryName() -> String? {
        return categoryLabel.text
    }
}

private extension UIView {
    static func createBorderView(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        return view
    }
}
