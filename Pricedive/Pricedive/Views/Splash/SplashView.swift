//
//  SplashView.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

class SplashView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientBackground()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientBackground()
    }

    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.mainBlue.cgColor,
            UIColor(hex: "5EA3FF")!.cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // 상단 중앙
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)   // 하단 중앙
        gradientLayer.frame = self.bounds
        gradientLayer.position = self.center
        self.layer.addSublayer(gradientLayer)
    }
}
