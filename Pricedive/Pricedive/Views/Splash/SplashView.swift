//
//  SplashView.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import SnapKit

class SplashView: UIView {

    private let logoLabel: UILabel = {
        let label = CustomStyles.logoText()
        label.textColor = UIColor.white
        label.font = UIFont(name: "HelveticaNeue-MediumItalic", size: 50)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = CustomStyles.splashDescriptionText()
        label.text = "SNS 속 숨겨진 특가,\n지금 찾아보세요!"
        label.textAlignment = .center
        return label
    }()

    private let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splashImage.png")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let additionalView: UIView = {
        let view = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .radial
        gradientLayer.colors = [
            UIColor(hex: "A1FFFF")!.withAlphaComponent(1.0).cgColor,
            UIColor(hex: "2C90EE")!.withAlphaComponent(0.0).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: Constants.additionalViewWidth, height: Constants.additionalViewHeight)
        view.layer.insertSublayer(gradientLayer, at: 0)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientBackground()
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientBackground()
        setupSubviews()
        setupConstraints()
    }

    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.mainBlue.cgColor,
            UIColor(hex: "5EA3FF")!.cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = self.bounds
        layer.addSublayer(gradientLayer)
    }

    private func setupSubviews() {
        addSubview(additionalView)
        addSubview(splashImageView)
        addSubview(logoLabel)
        addSubview(descriptionLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = additionalView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = additionalView.bounds
        }
    }

    private func setupConstraints() {
        logoLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(97)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(72)
        }

        splashImageView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-100)
            make.centerX.equalToSuperview()
            make.width.equalTo(301)
            make.height.equalTo(313)
        }

        additionalView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-77)
            make.centerX.equalToSuperview()
            make.width.equalTo(393)
            make.height.equalTo(429)
        }
    }
}
