//
//  UILabel+CustomStyle.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

extension UILabel {
    func setCustomStyle(text: String, color: UIColor, font: UIFont, lineHeight: CGFloat, kern: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeight
        
        let attributedText = NSMutableAttributedString(
            string: text,
            attributes: [
                .kern: kern,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        self.attributedText = attributedText
        self.textColor = color
        self.font = font
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
    }

    static func createCustomLabel(
        text: String,
        color: UIColor,
        font: UIFont,
        lineHeight: CGFloat,
        kern: CGFloat
    ) -> UILabel {
        let label = UILabel()
        label.setCustomStyle(text: text, color: color, font: font, lineHeight: lineHeight, kern: kern)
        return label
    }
}
