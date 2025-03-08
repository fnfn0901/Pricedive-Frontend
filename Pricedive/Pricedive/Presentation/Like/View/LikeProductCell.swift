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
    
    // MARK: - Properties
    private var event: Event?
    private var viewModel: HomeViewModel?

    // MARK: - UI Components
    private let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let dDayLabel = UILabel()
    private let eventTitleLabel = UILabel()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
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
        actionButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
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
            make.trailing.lessThanOrEqualTo(actionButton.snp.leading).offset(-8)
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
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(28)
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
    func configure(with event: Event, viewModel: HomeViewModel, style: LikeProductCell.EventStyle) {
        self.event = event
        self.viewModel = viewModel


        dDayLabel.text = event.dDayDescription
        eventTitleLabel.text = event.eventItem

        let formattedDate = formatDate(event.eventEndDate)
        endDateLabel.text = "이벤트 마감: \(formattedDate)"

        if let imageURL = URL(string: event.eventImage) {
            productImage.kf.setImage(with: imageURL)
        } else {
            print("❌ 이미지 URL 없음")
            productImage.image = nil
        }

        switch style {
        case .like:
            configureActionButtonForLike()
        case .myPage:
            configureActionButtonForMyPage()
        }
    }
    
    private func configureActionButtonForLike() {
        let imageName = "heart"
        let configuration = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        actionButton.setImage(image, for: .normal)
        actionButton.tintColor = UIColor.mainBlack
    }

    private func formatDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        isoFormatter.timeZone = TimeZone.current

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy.MM.dd"
        outputFormatter.locale = Locale(identifier: "ko_KR")

        if let date = isoFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            print("⚠️ 날짜 변환 실패: \(dateString)")
            return "날짜 오류"
        }
    }
    
    // MARK: - Helper Methods
    private func configureActionButtonForLike(_ isLiked: Bool) {
        let imageName = isLiked ? "heart.fill" : "heart"
        let configuration = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        actionButton.setImage(image, for: .normal)
        actionButton.tintColor = isLiked ? UIColor.mainRed : UIColor.mainBlack
    }
    
    private func configureActionButtonForMyPage() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)
        let image = UIImage(systemName: "xmark", withConfiguration: configuration)
        actionButton.setImage(image, for: .normal)
        actionButton.tintColor = UIColor.mainBlack
    }

    // MARK: - Action Methods
    @objc private func didTapLikeButton() {
        guard let event = event, let viewModel = viewModel else { return }

        viewModel.toggleLike(for: event.eventId)
    }
}
