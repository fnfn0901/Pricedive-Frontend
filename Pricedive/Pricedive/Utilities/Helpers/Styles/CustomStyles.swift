//
//  CustomStyles.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

struct CustomStyles {
    static func customLabel(
        text: String,
        color: UIColor,
        font: UIFont,
        lineHeight: CGFloat,
        kern: CGFloat
    ) -> UILabel {
        return UILabel.createCustomLabel(
            text: text,
            color: color,
            font: font,
            lineHeight: lineHeight,
            kern: kern
        )
    }

    static func productTitle() -> UILabel {
        return customLabel(
            text: "",
            color: UIColor.mainBlack,
            font: UIFont(name: "Pretendard-SemiBold", size: 14)!,
            lineHeight: 1.32,
            kern: -0.41
        )
    }

    static func categoryUnselected() -> UILabel {
        return customLabel(
            text: "",
            color: UIColor.mainBlack,
            font: UIFont(name: "Pretendard-Regular", size: 14)!,
            lineHeight: 1.32,
            kern: -0.41
        )
    }

    static func categorySelected() -> UILabel {
        return customLabel(
            text: "",
            color: UIColor.mainWhite,
            font: UIFont(name: "Pretendard-Regular", size: 14)!,
            lineHeight: 1.32,
            kern: -0.41
        )
    }

    static func dDayText() -> UILabel {
        return customLabel(
            text: "",
            color: UIColor.mainRed,
            font: UIFont(name: "Pretendard-Bold", size: 16)!,
            lineHeight: 1.15,
            kern: 1.5
        )
    }

    static func navigationText() -> UILabel {
        return customLabel(
            text: "",
            color: UIColor.mainBlack,
            font: UIFont(name: "Pretendard-Bold", size: 18)!,
            lineHeight: 1.02,
            kern: -0.41
        )
    }

    static func logoText() -> UILabel {
        return customLabel(
            text: "Pricedive",
            color: UIColor.mainBlue,
            font: UIFont(name: "HelveticaNeue-MediumItalic", size: 30)!,
            lineHeight: 0,
            kern: -0.41
        )
    }

    static func splashDescriptionText() -> UILabel {
        return customLabel(
            text: "",
            color: UIColor.white,
            font: UIFont(name: "NotoSans-Bold", size: 24)!,
            lineHeight: 1.1,
            kern: -0.41
        )
    }
}
