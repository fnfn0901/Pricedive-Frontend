//
//  LikeProductCell.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit
import SnapKit
import Kingfisher

final class LikeProductCell: UITableViewCell {
    enum EventStyle {
        case like
        case myPage
    }

    // MARK: - UI Components
    private let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let dDayLabel = UILabel()
    private let eventTitleLabel = UILabel()
    private let actionButton = UIButton()
    private let clockIcon = UIImageView()
    private let endDateLabel = UILabel()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupViews() {
        contentView.addSubviews(productImage, dDayLabel, eventTitleLabel, actionButton, clockIcon, endDateLabel)
    }

    private func setupConstraints() {
        productImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(12)
            make.height.width.equalTo(80)
            make.bottom.lessThanOrEqualToSuperview().offset(-8).priority(.low)
        }

        eventTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(productImage.snp.top)
            make.leading.equalTo(productImage.snp.trailing).offset(12)
        }

        dDayLabel.snp.makeConstraints { make in
            make.leading.equalTo(eventTitleLabel.snp.leading)
            make.bottom.equalTo(clockIcon.snp.top).offset(-4)
        }

        clockIcon.snp.makeConstraints { make in
            make.bottom.equalTo(productImage.snp.bottom)
            make.leading.equalTo(dDayLabel.snp.leading)
            make.size.equalTo(16)
        }

        endDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(clockIcon.snp.trailing).offset(4)
            make.centerY.equalTo(clockIcon.snp.centerY)
        }

        actionButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
            make.size.equalTo(24)
        }
    }

    private func configureAppearance() {
        backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.mainWhite.cgColor

        let selectedBackground = UIView()
        selectedBackground.backgroundColor = UIColor(hex: "#E5E7EB")
        selectedBackground.layer.cornerRadius = 12
        selectedBackground.layer.masksToBounds = true
        self.selectedBackgroundView = selectedBackground

        dDayLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        dDayLabel.textColor = UIColor.mainRed

        eventTitleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        eventTitleLabel.textColor = UIColor.mainBlack

        clockIcon.image = UIImage(systemName: "clock")
        clockIcon.tintColor = UIColor.placeholderGray
        clockIcon.contentMode = .scaleAspectFit

        endDateLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        endDateLabel.textColor = UIColor.placeholderGray
    }

    // MARK: - Configuration Method
    func configure(with event: Event, style: EventStyle) {
        dDayLabel.text = "D-\(event.dDay)"
        eventTitleLabel.text = event.eventTitle
        endDateLabel.text = "이벤트 마감: \(formattedDate(event.eventEndDate))"

        if let imageURL = URL(string: event.eventImage) {
            productImage.kf.setImage(with: imageURL)
        } else {
            productImage.image = nil
        }

        switch style {
        case .like:
            actionButton.setImage(UIImage(systemName: event.isLiked ? "heart.fill" : "heart"), for: .normal)
            actionButton.tintColor = UIColor.mainBlack
        case .myPage:
            actionButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            actionButton.tintColor = UIColor.mainRed
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. M. d."
        return formatter.string(from: date)
    }
}
