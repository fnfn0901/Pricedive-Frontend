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

    var viewModel: HomeViewModel?
    var eventId: Int?
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = CustomStyles.productTitle()
    private let profileView = UIView.createYoutuberProfileView(imageUrl: "")
    private let dDayView = UIView.createDDayView(text: "0")
    private lazy var heartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .mainBlack
        button.addTarget(self, action: #selector(handleHeartTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - State
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
        contentView.addSubviews([imageView, titleLabel])
        imageView.addSubviews([profileView, dDayView, heartButton])
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
            $0.width.height.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
    }

    // MARK: - Configuration
    func configureCell(event: Event, viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.eventId = event.eventId

        titleLabel.text = event.eventTitle
        imageView.kf.setImage(with: URL(string: event.eventImage))
        if let profileImageView = profileView.subviews.first as? UIImageView {
            profileImageView.kf.setImage(with: URL(string: event.youtuberProfileImage))
        }
        if let dDayLabel = dDayView.subviews.first(where: { $0 is UILabel }) as? UILabel {
            dDayLabel.text = "D-\(event.dDay)"
        }

        updateHeartButton(isLiked: viewModel.isLiked(for: event.eventId))
    }
    
    private func updateHeartButton(isLiked: Bool) {
        let imageName = isLiked ? "heart.fill" : "heart"
        let tintColor = isLiked ? UIColor.mainRed : UIColor.mainBlack
        heartButton.setImage(UIImage(systemName: imageName), for: .normal)
        heartButton.tintColor = tintColor
    }

    // MARK: - Actions
    @objc private func handleHeartTapped() {
        guard let viewModel = viewModel, let eventId = eventId else { return }
        viewModel.toggleLike(for: eventId)
        updateHeartButton(isLiked: viewModel.isLiked(for: eventId))
    }
}
