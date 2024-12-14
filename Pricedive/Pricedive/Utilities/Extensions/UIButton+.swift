//
//  UIButton+.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit

extension UIButton {
    func setCustomStyle(
        title: String,
        font: UIFont,
        textColor: UIColor,
        backgroundColor: UIColor,
        cornerRadius: CGFloat
    ) {
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: font,
                .foregroundColor: textColor
            ]
        )
        self.setAttributedTitle(attributedTitle, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
    }
}
