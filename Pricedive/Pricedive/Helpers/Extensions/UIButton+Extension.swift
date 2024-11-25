//
//  UIButton+Extension.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

extension UIButton {
    static func createIconButton(image: UIImage?, target: Any?, action: Selector?) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .mainBlack
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        return button
    }
}
