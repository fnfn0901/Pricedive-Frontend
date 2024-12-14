//
//  UIButton+Factory.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit

extension UIButton {
    // 기본 아이콘
    static func createIconButton(image: UIImage?, target: Any?, action: Selector?) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .mainBlack
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        return button
    }

    // 선택된 카테고리 버튼
    static func createSelectedCategoryButton(title: String, size: CGSize = CGSize(width: 100, height: 40)) -> UIButton {
        let button = UIButton(type: .system)
        button.layer.backgroundColor = UIColor.mainBlue.cgColor
        button.layer.cornerRadius = size.height / 2
        button.setTitle(title, for: .normal)
        button.setTitleColor(.mainWhite, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.snp.makeConstraints { make in
            make.width.equalTo(size.width)
            make.height.equalTo(size.height)
        }
        return button
    }

    // 미선택 카테고리 버튼
    static func createUnselectedCategoryButton(title: String, size: CGSize = CGSize(width: 100, height: 40)) -> UIButton {
        let button = UIButton(type: .system)
        button.layer.backgroundColor = UIColor.mainWhite.cgColor
        button.layer.cornerRadius = size.height / 2
        button.setTitle(title, for: .normal)
        button.setTitleColor(.mainBlack, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.snp.makeConstraints { make in
            make.width.equalTo(size.width)
            make.height.equalTo(size.height)
        }
        return button
    }
}
