//
//  UILabel+CustomStyle.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

extension UILabel {
    func applyCustomStyle(attributedText: NSAttributedString, color: UIColor, font: UIFont) {
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
        let attributedText = NSAttributedString.customAttributedString(
            text: text,
            font: font,
            lineHeight: lineHeight,
            kern: kern
        )
        label.applyCustomStyle(attributedText: attributedText, color: color, font: font)
        return label
    }
}

extension NSAttributedString {
    static func customAttributedString(text: String, font: UIFont, lineHeight: CGFloat, kern: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeight

        return NSAttributedString(
            string: text,
            attributes: [
                .kern: kern,
                .paragraphStyle: paragraphStyle,
                .font: font
            ]
        )
    }
}
