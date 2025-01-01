//
//  SplashView.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import SnapKit

class SplashView: UIView {
    
    private let backgroundGradientLayer = CAGradientLayer()
    private let spotlightGradientLayer = CAGradientLayer()
    
    private let logoLabel: UILabel = {
        let label = CustomStyles.logoText()
        label.textColor = .white
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayers()
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayers()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupGradientLayers() {
        configureGradientLayer(
            layer: backgroundGradientLayer,
            colors: [UIColor.mainBlue.cgColor, UIColor(hex: "5EA3FF")!.cgColor],
            locations: [0, 1],
            startPoint: CGPoint(x: 0.5, y: 0.0),
            endPoint: CGPoint(x: 0.5, y: 1.0)
        )
        layer.insertSublayer(backgroundGradientLayer, at: 0)
        
        configureGradientLayer(
            layer: spotlightGradientLayer,
            colors: [
                UIColor(hex: "A1FFFF")!.withAlphaComponent(1.0).cgColor,
                UIColor(hex: "2C90EE")!.withAlphaComponent(0.0).cgColor
            ],
            locations: [0.0, 1.0],
            startPoint: CGPoint(x: 0.5, y: 0.5),
            endPoint: CGPoint(x: 1.0, y: 1.0),
            type: .radial
        )
        layer.insertSublayer(spotlightGradientLayer, at: 1)
    }
    
    private func configureGradientLayer(
        layer: CAGradientLayer,
        colors: [CGColor],
        locations: [NSNumber],
        startPoint: CGPoint,
        endPoint: CGPoint,
        type: CAGradientLayerType = .axial
    ) {
        layer.colors = colors
        layer.locations = locations
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        layer.type = type
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundGradientLayer.frame = bounds

        let spotlightSize = max(splashImageView.bounds.width, splashImageView.bounds.height) * 1.5
        spotlightGradientLayer.frame = CGRect(
            x: splashImageView.frame.midX - spotlightSize / 2,
            y: splashImageView.frame.midY - spotlightSize / 2,
            width: spotlightSize,
            height: spotlightSize
        )
    }
    
    private func setupSubviews() {
        addSubviews(splashImageView, logoLabel, descriptionLabel)
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
    }
}
