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
    var eventId: Int?
    
    private var isRequestingLike = false

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
        label.baselineAdjustment = .alignBaselines
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
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
        button.isUserInteractionEnabled = true
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
        contentView.addSubviews(imageView, titleLabel, heartButton)
        imageView.addSubviews(profileView, dDayView)
        
        contentView.isUserInteractionEnabled = true
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
            $0.trailing.bottom.equalTo(imageView).offset(-5)
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
        self.eventId = event.eventId

        setTitle(event.eventItem)
        setImage(event.eventImage)
        setProfileImage(event.channelImg)
        updateHeartButton(isLiked: viewModel.isLiked(for: event.videoId ?? -1))
        updateDDayView(with: event.dDayDescription)
        setupHeartButtonInteraction()

        heartButton.addTarget(self, action: #selector(handleHeartTapped), for: .touchUpInside)
    }
    
    private func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    private func setImage(_ imageUrl: String) {
        imageView.kf.setImage(with: URL(string: imageUrl))
    }
    
    private func setProfileImage(_ profileUrl: String) {
        if let url = URL(string: profileUrl) {
            profileView.kf.setImage(with: url)
        }
    }
    
    private func updateDDayView(with text: String) {
        if let label = dDayView.subviews.first as? UILabel {
            label.text = text
        }
    }
    
    private func setupHeartButtonInteraction() {
        contentView.isUserInteractionEnabled = true
    }
    
    func updateHeartButton(isLiked: Bool) {
        let imageName = isLiked ? "heart.fill" : "heart"
        let tintColor = isLiked ? UIColor.mainRed : UIColor.black
        heartButton.setImage(UIImage(systemName: imageName), for: .normal)
        heartButton.tintColor = tintColor
    }

    @objc private func handleHeartTapped() {
        guard let viewModel = viewModel, let videoId = videoId, !isRequestingLike else { return }
        
        isRequestingLike = true
        heartButton.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.1, animations: {
            self.heartButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.heartButton.transform = CGAffineTransform.identity
            }
        }

        viewModel.toggleLike(for: videoId) { [weak self] isLiked in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.updateHeartButton(isLiked: isLiked)
                self.heartButton.isUserInteractionEnabled = true
                self.isRequestingLike = false
            }
        }
    }
}
