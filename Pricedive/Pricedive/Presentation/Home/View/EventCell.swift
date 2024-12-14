//
//  EventCell.swift
//  Pricedive
//
//  Created by 신호연 on 11/26/24.
//

import UIKit
import SnapKit
import Kingfisher

class EventCell: UICollectionViewCell {
    // MARK: - Properties
    private let imageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = CustomStyles.productTitle()
        label.text = ""
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private let profileView: UIView = {
        UIView.createYoutuberProfileView(imageUrl: "")
    }()
    
    private let dDayView: UIView = {
        let view = UIView.createDDayView(text: "0")
        return view
    }()
    
    private lazy var heartButton: UIButton = {
        let button = UIButton.createIconButton(image: UIImage(systemName: "heart"), target: self, action: #selector(handleHeartTapped))
        return button
    }()
    
    private var isHeartSelected = false
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        imageView.fillWithImage("")
        imageView.addSubview(profileView)
        imageView.addSubview(dDayView)
        imageView.addSubview(heartButton)
    }
    
    private func setupConstraints() {
        // ImageView
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(124)
        }
        
        // ProfileView
        profileView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).offset(5)
            make.leading.equalTo(imageView.snp.leading).offset(5)
            make.width.height.equalTo(36)
        }
        
        // D-Day View
        dDayView.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.leading)
            make.bottom.equalTo(imageView.snp.bottom)
            make.width.equalTo(54)
            make.height.equalTo(29)
        }
        
        // Heart Button
        heartButton.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).offset(-5)
            make.trailing.equalTo(imageView.snp.trailing).offset(-5)
        }
        
        // Title Label
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().priority(.low)
        }
    }
    
    // MARK: - Configure Method
    func configureCell(title: String, imageUrl: String, profileImageUrl: String, dDayText: String) {
        updateTitleLabel(with: title)
        updateImageView(with: imageUrl)
        updateProfileView(with: profileImageUrl)
        updateDDayView(with: dDayText)
    }
    
    private func updateTitleLabel(with text: String) {
        titleLabel.text = text
    }
    
    private func updateImageView(with urlString: String) {
        if let imageView = imageView.subviews.first as? UIImageView {
            imageView.kf.setImage(with: URL(string: urlString))
        }
    }
    
    private func updateProfileView(with urlString: String) {
        if let profileImageView = profileView.subviews.first as? UIImageView {
            profileImageView.kf.setImage(with: URL(string: urlString))
        }
    }
    
    private func updateDDayView(with text: String) {
        if let dDayLabel = dDayView.subviews.first(where: { $0 is UILabel }) as? UILabel {
            dDayLabel.text = "D-\(text)"
        }
    }
    
    // MARK: - Actions
    @objc private func handleHeartTapped() {
        isHeartSelected.toggle()
        let imageName = isHeartSelected ? "heart.fill" : "heart"
        let tintColor = isHeartSelected ? UIColor.mainRed : UIColor.mainBlack
        heartButton.setImage(UIImage(systemName: imageName), for: .normal)
        heartButton.tintColor = tintColor
    }
}
