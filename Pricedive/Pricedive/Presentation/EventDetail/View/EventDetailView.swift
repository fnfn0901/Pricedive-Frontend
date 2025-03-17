//
//  EventDetailView.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit
import SnapKit

class EventDetailView: UIView {

    // MARK: - Properties
    var eventId: Int?
    var viewModel: EventDetailViewModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - UI Components
    let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private var isSearchBarVisible = false

    let logoLabel: UILabel = CustomStyles.logoText()

    let backIconButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.backward")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()

    let scrollView = UIScrollView()
    let contentView = UIView()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .mainWhite
        return imageView
    }()

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

    private var dDayView: UIView = UIView()
    
    lazy var heartButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")
        config.imagePadding = 0
        config.baseForegroundColor = .mainBlack
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        button.configuration = config
        
        button.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        
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

    var gptLabel: UILabel = {
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
        button.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(makeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let formButton: UIButton = {
        let button = UIButton(type: .system)
        button.setCustomStyle(
            title: "폼 신청하기",
            font: UIFont(name: "Pretendard-Medium", size: 14)!,
            textColor: .white,
            backgroundColor: UIColor.mainBlue,
            cornerRadius: 10
        )
        return button
    }()
    
    let goToButton: UIButton = {
        let button = UIButton(type: .system)
        button.setCustomStyle(
            title: "영상 바로가기",
            font: UIFont(name: "Pretendard-Medium", size: 14)!,
            textColor: .white,
            backgroundColor: UIColor.mainBlue,
            cornerRadius: 10
        )
        return button
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        backgroundColor = .white
        addSubviews(navigationBar, scrollView, bottomView)

        navigationBar.addSubviews(logoLabel, backIconButton)

        scrollView.addSubview(contentView)

        contentView.addSubviews(imageView, titleLabel, eventContentView, gptContentView)
        eventContentView.addSubviews(eventContentTitleLabel, eventDescriptionLabel)

        imageView.addSubviews(profileView, dDayView, heartButton)

        gptContentView.addSubviews(gptLabel, copyButton, makeButton, loadingIndicator)

        bottomView.addSubviews(formButton, goToButton)

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
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
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
            $0.trailing.bottom.equalToSuperview().offset(-20)
            $0.size.equalTo(24)
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
            $0.height.greaterThanOrEqualTo(150)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        gptLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.lessThanOrEqualTo(copyButton.snp.top).offset(-8)
        }
        
        copyButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(5)
            $0.trailing.equalTo(makeButton.snp.leading).offset(-4)
            $0.size.equalTo(CGSize(width: 80, height: 36))
        }
        
        makeButton.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(5)
            $0.size.equalTo(CGSize(width: 80, height: 36))
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(75)
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        formButton.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(goToButton.snp.leading).offset(-10)
            $0.height.equalTo(48)
            $0.width.equalTo(goToButton.snp.width)
        }

        goToButton.snp.remakeConstraints {
            $0.top.equalTo(formButton)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
            $0.width.equalTo(formButton.snp.width)
        }
    }

    // MARK: - Configuration
    func configureCell(
        title: String,
        imageUrl: String,
        profileImageUrl: String,
        dDayText: String,
        eventDescription: String?
    ) {
        titleLabel.text = title
        imageView.kf.setImage(with: URL(string: imageUrl))
        if let profileImageView = profileView.subviews.first as? UIImageView {
            profileImageView.kf.setImage(with: URL(string: profileImageUrl))
        }
        if let dDayLabel = dDayView.subviews.first(where: { $0 is UILabel }) as? UILabel {
            dDayLabel.text = viewModel?.event.dDayDescription ?? "D-?"
        }
        eventDescriptionLabel.text = eventDescription ?? ""
    }

    @objc private func heartButtonTapped() {
        guard let viewModel = viewModel else {
            print("❌ Error: ViewModel이 존재하지 않음")
            return
        }

        let eventId = viewModel.event.eventId
        let userId = viewModel.userId

        let isCurrentlyLiked = viewModel.isLiked
        let newLikeState = !isCurrentlyLiked

        updateHeartButton(isLiked: newLikeState)
        heartButton.isUserInteractionEnabled = false

        viewModel.toggleLikeStatus(userId: userId, eventId: eventId) { [weak self] isLiked in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.updateHeartButton(isLiked: isLiked)
                self.heartButton.isUserInteractionEnabled = true
            }
        }
    }

    /// **하트 버튼 UI 업데이트**
    func updateHeartButton(isLiked: Bool) {
        DispatchQueue.main.async {
            let imageName = isLiked ? "heart.fill" : "heart"
            let tintColor = isLiked ? UIColor.mainRed : UIColor.mainBlack

            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: imageName)
            config.baseForegroundColor = tintColor
            config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)

            self.heartButton.configuration = config
        }
    }
    
    // MARK: - Update View
    private func updateView() {
        guard let viewModel = viewModel else { return }

        titleLabel.text = viewModel.event.eventItem
        eventDescriptionLabel.text = viewModel.event.eventDescription
        updateHeartButton(isLiked: viewModel.isLiked)

        setupDDayView()
    }

    func updateVideoView(with video: VideoDTO, isLiked: Bool) {
        titleLabel.text = video.title
        eventDescriptionLabel.text = video.description

        if let profileImageView = profileView.subviews.first as? UIImageView {
            profileImageView.kf.setImage(with: URL(string: video.channelImg))
        }

        if let previewImg = viewModel?.event.eventImage, let url = URL(string: previewImg) {
            imageView.kf.setImage(with: url)
        }

        updateHeartButton(isLiked: isLiked)
    }
    
    func updateVideoView(with video: VideoDTO) {
        titleLabel.text = video.title
        eventDescriptionLabel.text = video.description

        if let profileImageView = profileView.subviews.first as? UIImageView {
            profileImageView.kf.setImage(with: URL(string: video.channelImg))
        }

        if let previewImg = viewModel?.previewImg, let url = URL(string: previewImg) {
            DispatchQueue.main.async {
                self.imageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "placeholder"),
                    options: [
                        .transition(.fade(0.3)),
                        .cacheOriginalImage
                    ],
                    completionHandler: { result in
                        switch result {
                        case .success(let value):
                            print("✅ 이미지 업데이트 성공: \(value.source.url?.absoluteString ?? "")")
                        case .failure(let error):
                            print("❌ 이미지 업데이트 실패: \(error.localizedDescription)")
                        }
                    }
                )
            }
        }
    }
    
    @objc private func makeButtonTapped() {
        guard let viewModel = viewModel else { return }

        gptLabel.text = "댓글을 생성 중입니다..."
        loadingIndicator.startAnimating()

        viewModel.generateGPTComment()
    }

    @objc private func copyButtonTapped() {
        guard let comment = gptLabel.text, !comment.isEmpty else {
            print("⚠️ 복사할 댓글이 없습니다.")
            return
        }
        UIPasteboard.general.string = comment
    }
    
    private func setupDDayView() {
        guard let event = viewModel?.event else { return }
        
        let dDayText = event.dDayDescription
        dDayView = UIView.createDDayView(dDayDescription: dDayText)

        if let label = dDayView.subviews.first(where: { $0 is UILabel }) as? UILabel {
            label.font = UIFont(name: "Pretendard-Bold", size: 22)
        }

        self.imageView.addSubview(dDayView)

        dDayView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: 102, height: 59))
        }
    }
}
