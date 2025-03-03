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
    var videoId: Int?

    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let profileView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .mainWhite
        return imageView
    }()
    
    private let dDayView = UIView.createDDayView(dDayDescription: "D-?")

    lazy var heartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .mainBlack
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleHeartTapped), for: .touchUpInside)
        return button
    }()

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
        contentView.addSubviews(imageView, titleLabel)
        imageView.addSubviews(profileView, dDayView, heartButton)
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
            $0.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
        }
    }

    func configureCell(event: Event, viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.videoId = event.videoId

        titleLabel.text = event.eventItem
        imageView.kf.setImage(with: URL(string: event.eventImage))
        
        if let profileURL = URL(string: event.channelImg) {
            profileView.kf.setImage(with: profileURL)
        }

        updateHeartButton(isLiked: viewModel.isLiked(for: event.videoId ?? -1))
        updateDDayView(with: event.dDayDescription ?? "D-?")
    }

    private func updateDDayView(with text: String) {
        if let label = dDayView.subviews.first as? UILabel {
            label.text = text
        }
    }

    @objc private func handleHeartTapped() {
        guard let viewModel = viewModel, let videoId = videoId else { return }
        viewModel.toggleLike(for: videoId)
    }

    func updateHeartButton(isLiked: Bool) {
        let imageName = isLiked ? "heart.fill" : "heart"
        let tintColor = isLiked ? UIColor.red : UIColor.black
        heartButton.setImage(UIImage(systemName: imageName), for: .normal)
        heartButton.tintColor = tintColor
    }
}
