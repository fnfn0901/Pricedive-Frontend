//
//  LikeProductCell.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit
import SnapKit

final class LikeProductCell: UITableViewCell {
    // MARK: - UI Components
    private let productInfoLabel = UILabel()
    private let heartButton = UIButton()
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
        contentView.addSubview(productInfoLabel)
        contentView.addSubview(heartButton)
        contentView.addSubview(clockIcon)
        contentView.addSubview(endDateLabel)
    }

    private func setupConstraints() {
        productInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }

        heartButton.snp.makeConstraints { make in
            make.centerY.equalTo(productInfoLabel)
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(24)
        }

        clockIcon.snp.makeConstraints { make in
            make.leading.equalTo(productInfoLabel)
            make.bottom.equalToSuperview().offset(-16)
            make.size.equalTo(16)
        }

        endDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(clockIcon.snp.trailing).offset(8)
            make.centerY.equalTo(clockIcon)
        }
    }

    private func configureAppearance() {
        backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.mainWhite.cgColor
        
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = UIColor(hex: "#E5E7EB") // 원하는 어두운 색상
        selectedBackground.layer.cornerRadius = 12
        selectedBackground.layer.masksToBounds = true
        self.selectedBackgroundView = selectedBackground

        productInfoLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        productInfoLabel.textColor = UIColor.mainBlack

        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.tintColor = UIColor.mainBlack

        clockIcon.image = UIImage(systemName: "clock")
        clockIcon.tintColor = UIColor.placeholderGray
        clockIcon.contentMode = .scaleAspectFit

        endDateLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        endDateLabel.textColor = UIColor.placeholderGray
    }

    // MARK: - Configuration Method
    func configure(with event: Event) {
        let fullText = "D-\(event.dDay) \(event.eventTitle)"
        let attributedText = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont(name: "Pretendard-SemiBold", size: 14)!,
                .foregroundColor: UIColor.mainBlack
            ]
        )
        if let range = fullText.range(of: "D-\(event.dDay)") {
            attributedText.addAttributes(
                [.foregroundColor: UIColor.mainRed],
                range: NSRange(range, in: fullText)
            )
        }
        productInfoLabel.attributedText = attributedText
        endDateLabel.text = "이벤트 마감: \(formattedDate(event.eventEndDate))"
        heartButton.setImage(
            UIImage(systemName: event.isLiked ? "heart.fill" : "heart"),
            for: .normal
        )
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. M. d."
        return formatter.string(from: date)
    }
}
