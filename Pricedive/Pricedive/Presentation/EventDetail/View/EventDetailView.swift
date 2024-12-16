//
//  EventDetailView.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit
import SnapKit

class EventDetailView: UIView {
    
    var eventId: Int?
    var viewModel: HomeViewModel?
    
    let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let logoLabel: UILabel = CustomStyles.logoText()
    
    let backIconButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.backward")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let searchIconButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "magnifyingglass")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
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
        return button
    }()
    
    private var isHeartSelected = false
    
    private let eventContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F9F9F9")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let eventContentTitleLabel: UILabel = {
        let label = CustomStyles.customLabel(
            text: "이벤트 내용",
            color: UIColor.mainBlack,
            font: UIFont(name: "Pretendard-SemiBold", size: 15)!,
            lineHeight: 1.2,
            kern: 0
        )
        return label
    }()
    
    private let eventDescriptionLabel: UILabel = {
        let label = CustomStyles.customLabel(
            text: "",
            color: UIColor.mainBlack,
            font: UIFont(name: "Pretendard-Regular", size: 14)!,
            lineHeight: 1.2,
            kern: 0
        )
        return label
    }()
    
    private let gptContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "#E0E0E0")?.cgColor
        return view
    }()
    
    private let gptLabel: UILabel = {
        let label = CustomStyles.customLabel(
            text: "생성 버튼을 눌러보세요. GPT가 자동으로 댓글을 작성해드립니다!",
            color: UIColor(hex: "#AAAAAA")!,
            font: UIFont(name: "Pretendard-Regular", size: 16)!,
            lineHeight: 1.2,
            kern: 0
        )
        return label
    }()
    
    private let copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setCustomStyle(
            title: "복사",
            font: UIFont(name: "Pretendard-Medium", size: 14)!,
            textColor: .white,
            backgroundColor: UIColor(hex: "#4A90E2")!,
            cornerRadius: 4
        )
        return button
    }()
    
    private let makeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setCustomStyle(
            title: "생성",
            font: UIFont(name: "Pretendard-Medium", size: 14)!,
            textColor: .white,
            backgroundColor: UIColor(hex: "#7ED321")!,
            cornerRadius: 4
        )
        return button
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let goToButton: UIButton = {
        let button = UIButton(type: .system)
        button.setCustomStyle(
            title: "바로가기",
            font: UIFont(name: "Pretendard-Medium", size: 14)!,
            textColor: .white,
            backgroundColor: UIColor.mainBlue,
            cornerRadius: 10
        )
        return button
    }()

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
        
        contentView.addSubviews([imageView, titleLabel, eventContentView, gptContentView])
        eventContentView.addSubviews([eventContentTitleLabel, eventDescriptionLabel])
        
        imageView.addSubviews([profileView, dDayView, heartButton])
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        gptContentView.addSubviews([gptLabel, copyButton, makeButton])
        
        addSubview(bottomView)
        bottomView.addSubviews([goToButton])
        
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
            make.top.equalTo(navigationBar.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(goToButton.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.height.equalToSuperview().priority(.low)
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
        }
        
        eventContentView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        eventContentTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        eventDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(eventContentTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        gptContentView.snp.makeConstraints {
            $0.top.equalTo(eventContentView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.lessThanOrEqualTo(352)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        gptLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        copyButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(5)
            $0.trailing.equalTo(makeButton.snp.leading).offset(-4)
            $0.height.equalTo(36)
            $0.width.equalTo(80)
        }
        
        makeButton.snp.makeConstraints{
            $0.top.equalTo(gptLabel.snp.bottom).offset(50)
            $0.bottom.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(36)
            $0.width.equalTo(80)
        }
        
        bottomView.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(75)
        }
        
        goToButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
    }
    
    func configureCell(title: String, imageUrl: String, profileImageUrl: String, dDayText: String, eventDescription: String?) {
        titleLabel.text = title
        imageView.kf.setImage(with: URL(string: imageUrl))
        if let profileImageView = profileView.subviews.first as? UIImageView {
            profileImageView.kf.setImage(with: URL(string: profileImageUrl))
        }
        if let dDayLabel = dDayView.subviews.first(where: { $0 is UILabel }) as? UILabel {
            dDayLabel.text = "D-\(dDayText)"
        }
        eventDescriptionLabel.text = eventDescription ?? ""
    }
    
    private func updateHeartButton(isLiked: Bool) {
        let imageName = isLiked ? "heart.fill" : "heart"
        let tintColor = isLiked ? UIColor.mainRed : UIColor.mainBlack
        heartButton.setImage(UIImage(systemName: imageName), for: .normal)
        heartButton.tintColor = tintColor
    }
    
    @objc private func handleHeartTapped() {
        guard let viewModel = viewModel, let eventId = eventId else { return }
        viewModel.toggleLike(for: eventId)
        updateHeartButton(isLiked: viewModel.isLiked(for: eventId))
    }
}
