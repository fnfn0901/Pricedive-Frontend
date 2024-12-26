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
    private let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let dDayLabel = UILabel()
    private let eventTitleLabel = UILabel()
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
        contentView.addSubviews(productImage, dDayLabel, eventTitleLabel, heartButton, clockIcon, endDateLabel)
    }
    
    private func setupConstraints() {
        productImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.height.width.equalTo(80)
        }
        
        eventTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(productImage.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(16)
        }

        dDayLabel.snp.makeConstraints { make in
            make.leading.equalTo(eventTitleLabel.snp.leading)
            make.top.equalTo(eventTitleLabel.snp.bottom).offset(6)
        }
        
        clockIcon.snp.makeConstraints { make in
            make.leading.equalTo(dDayLabel.snp.leading)
            make.top.equalTo(dDayLabel.snp.bottom).offset(6)
            make.size.equalTo(16)
        }
        
        endDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(clockIcon.snp.trailing).offset(4)
            make.centerY.equalTo(clockIcon.snp.centerY)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        heartButton.snp.makeConstraints { make in
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
        
        eventTitleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        eventTitleLabel.textColor = UIColor.mainBlack
        
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
        dDayLabel.text = "D-\(event.dDay)"
        eventTitleLabel.text = event.eventTitle
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
