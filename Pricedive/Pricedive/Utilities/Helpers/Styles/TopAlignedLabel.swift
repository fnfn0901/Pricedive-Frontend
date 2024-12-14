//
//  TopAlignedLabel.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit

class TopAlignedLabel: UILabel {

    override func drawText(in rect: CGRect) {
        guard let text = text else {
            super.drawText(in: rect)
            return
        }

        let attributedText = self.attributedText ?? NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 14)])
        let textRect = attributedText.boundingRect(
            with: CGSize(width: rect.width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )

        let adjustedRect = CGRect(
            origin: CGPoint(x: rect.origin.x, y: rect.origin.y),
            size: CGSize(width: rect.width, height: ceil(textRect.height))
        )

        super.drawText(in: adjustedRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width, height: size.height)
    }
}
