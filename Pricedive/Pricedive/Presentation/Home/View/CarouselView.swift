//
//  CarouselView.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import SnapKit
import Kingfisher

class CarouselView: UIView {

    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private var imageViews: [UIImageView] = []
    private var timer: Timer?

    var imageUrls: [String] = [] {
        didSet {
            configureCarousel()
            setupAutoSlide()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .mainWhite
        setupScrollView()
        setupPageControl()
    }

    private func setupScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupPageControl() {
        pageControl.hidesForSinglePage = true
        addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
        }
    }

    private func configureCarousel() {
        // 기존 뷰 초기화
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews = []
        pageControl.numberOfPages = 0
        timer?.invalidate()

        guard !imageUrls.isEmpty else {
            scrollView.contentSize = .zero
            return
        }

        // 이미지 추가
        var previousImageView: UIImageView? = nil
        for (index, urlString) in imageUrls.enumerated() {
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            imageView.kf.setImage(with: URL(string: urlString))
            scrollView.addSubview(imageView)
            imageViews.append(imageView)

            imageView.snp.makeConstraints { make in
                make.width.height.equalToSuperview()
                if let previous = previousImageView {
                    make.leading.equalTo(previous.snp.trailing)
                } else {
                    make.leading.equalToSuperview()
                }
                if index == imageUrls.count - 1 {
                    make.trailing.equalToSuperview()
                }
            }

            previousImageView = imageView
        }

        // 페이지 컨트롤 설정
        if imageUrls.count > 1 {
            pageControl.numberOfPages = imageUrls.count
            pageControl.isHidden = false
        } else {
            pageControl.isHidden = true
        }
    }

    private func setupAutoSlide() {
        guard imageUrls.count > 1 else { return }

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.autoSlide()
        }
    }

    private func autoSlide() {
        guard !imageUrls.isEmpty else { return }

        let currentPage = pageControl.currentPage
        let nextPage = (currentPage + 1) % imageUrls.count
        let offsetX = CGFloat(nextPage) * frame.width

        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        pageControl.currentPage = nextPage
    }

    deinit {
        timer?.invalidate()
    }
}

extension CarouselView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / frame.width)
        pageControl.currentPage = Int(pageIndex)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 사용자 인터랙션 중에는 자동 슬라이드 일시 정지
        timer?.invalidate()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 사용자 인터랙션 후 자동 슬라이드 재시작
        setupAutoSlide()
    }
}
