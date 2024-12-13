//
//  UIButton+.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
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
        button.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        return button
    }
    
    // 버튼 클릭 애니메이션
    func animateNaturalTouch(completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.1,
                    delay: 0,
                    options: [.curveEaseIn],
                    animations: {
                        self.transform = .identity
                    },
                    completion: { _ in
                        completion?()
                    }
                )
            }
        )
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
        button.layer.cornerRadius = 20
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
        button.layer.cornerRadius = 20
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
