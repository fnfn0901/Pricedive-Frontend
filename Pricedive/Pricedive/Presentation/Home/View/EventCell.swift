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

    private let imageView = UIImageView()
    private let titleLabel = CustomStyles.productTitle()
    private let profileView = UIView.createYoutuberProfileView(imageUrl: "")
    private let dDayView = UIView.createDDayView(text: "0")
    private lazy var heartButton: UIButton = {
        UIButton.createIconButton(image: UIImage(systemName: "heart"), target: self, action: #selector(handleHeartTapped))
    }()

    private var isHeartSelected = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubviews([imageView, titleLabel])
        imageView.addSubviews([profileView, dDayView, heartButton])
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.snp.width).multipliedBy(0.65)
        }

        profileView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(5)
            $0.size.equalTo(36)
        }

        dDayView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: 54, height: 29))
        }

        heartButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().offset(-5)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
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
