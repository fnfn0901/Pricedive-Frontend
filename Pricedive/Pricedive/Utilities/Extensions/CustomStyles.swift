//
//  CustomStyles.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

struct CustomStyles {
    static func productTitle() -> UILabel {
        return UILabel.createCustomLabel(
            text: "",
            color: UIColor.mainBlack,
            font: UIFont(name: "Pretendard-SemiBold", size: 14)!,
            lineHeight: 1.32,
            kern: -0.41
        )
    }

    static func categoryUnselected() -> UILabel {
        return UILabel.createCustomLabel(
            text: "",
            color: UIColor.mainBlack,
            font: UIFont(name: "Pretendard-Regular", size: 14)!,
            lineHeight: 1.32,
            kern: -0.41
        )
    }

    static func categorySelected() -> UILabel {
        return UILabel.createCustomLabel(
            text: "",
            color: UIColor.mainWhite,
            font: UIFont(name: "Pretendard-Regular", size: 14)!,
            lineHeight: 1.32,
            kern: -0.41
        )
    }

    static func dDayText() -> UILabel {
        return UILabel.createCustomLabel(
            text: "",
            color: UIColor.mainRed,
            font: UIFont(name: "Pretendard-Bold", size: 16)!,
            lineHeight: 1.15,
            kern: 1.5
        )
    }

    static func navigationText() -> UILabel {
        return UILabel.createCustomLabel(
            text: "",
            color: UIColor.mainBlack,
            font: UIFont(name: "Pretendard-Bold", size: 18)!,
            lineHeight: 1.02,
            kern: -0.41
        )
    }
    
    static func logoText() -> UILabel {
        return UILabel.createCustomLabel(
            text: "",
            color: UIColor.mainBlue,
            font: UIFont(name: "HelveticaNeueMediumItalic", size: 30)!,
            lineHeight: 0.6,
            kern: -0.41
        )
    }
}
