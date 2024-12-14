//
//  EventDetailView.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit
import SnapKit

class EventDetailView: UIView {

    let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let logoLabel: UILabel = CustomStyles.logoText()

    let backIconButton: UIButton = {
        let image = UIImage(systemName: "chevron.backward")
        return UIButton.createIconButton(image: image, target: nil, action: nil)
    }()

    let searchIconButton: UIButton = {
        let image = UIImage(systemName: "magnifyingglass")
        return UIButton.createIconButton(image: image, target: nil, action: nil)
    }()

    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    private let imageView = UIImageView()
    private let titleLabel: UILabel = {
        let label = CustomStyles.productTitle()
        label.font = UIFont(name: "Pretendard-Bold", size: 18)
        return label
    }()
    private let profileView: UIView = {
        let view = UIView.createYoutuberProfileView(imageUrl: "")
        view.layer.cornerRadius = 45
        view.snp.remakeConstraints { make in
            make.width.height.equalTo(90)
        }
        return view
    }()
    private let dDayView: UIView = {
        let view = UIView.createDDayView(text: "0")
        if let label = view.subviews.first(where: { $0 is UILabel }) as? UILabel {
            label.font = UIFont(name: "Pretendard-Bold", size: 22)
        }
        return view
    }()
    private lazy var heartButton: UIButton = {
        let button = UIButton(type: .system)
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")
        config.imagePadding = 0
        config.baseForegroundColor = .mainBlack
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)

        button.configuration = config
        button.addTarget(self, action: #selector(handleHeartTapped), for: .touchUpInside)
        
        return button
    }()
    
    private var isHeartSelected = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .white
        addSubview(navigationBar)

        navigationBar.addSubview(logoLabel)
        navigationBar.addSubview(backIconButton)
        navigationBar.addSubview(searchIconButton)
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([imageView, titleLabel])
        imageView.addSubviews([profileView, dDayView, heartButton])
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        setupConstraints()
    }

    private func setupConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }

        logoLabel.snp.makeConstraints { make in
            make.center.equalTo(navigationBar)
        }

        backIconButton.snp.makeConstraints { make in
            make.leading.equalTo(navigationBar).offset(20)
            make.centerY.equalTo(navigationBar)
        }

        searchIconButton.snp.makeConstraints { make in
            make.trailing.equalTo(navigationBar).offset(-20)
            make.centerY.equalTo(navigationBar)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(6)
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.snp.width).multipliedBy(0.65)
        }

        profileView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.size.equalTo(90)
        }

        dDayView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: 102, height: 59))
        }

        heartButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().offset(-12)
            $0.width.height.equalTo(36)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
    }

    func configureCell(title: String, imageUrl: String, profileImageUrl: String, dDayText: String) {
        titleLabel.text = title
        imageView.kf.setImage(with: URL(string: imageUrl))
        if let profileImageView = profileView.subviews.first as? UIImageView {
            profileImageView.kf.setImage(with: URL(string: profileImageUrl))
        }
        if let dDayLabel = dDayView.subviews.first(where: { $0 is UILabel }) as? UILabel {
            dDayLabel.text = "D-\(dDayText)"
        }
    }

    @objc private func handleHeartTapped() {
        isHeartSelected.toggle()
        let imageName = isHeartSelected ? "heart.fill" : "heart"
        let tintColor = isHeartSelected ? UIColor.mainRed : UIColor.mainBlack
        heartButton.setImage(UIImage(systemName: imageName), for: .normal)
        heartButton.tintColor = tintColor
    }
}
