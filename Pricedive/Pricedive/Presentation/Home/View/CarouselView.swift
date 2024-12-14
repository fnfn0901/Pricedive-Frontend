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
            setupCarousel()
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

        addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }

        addSubview(pageControl)
        pageControl.hidesForSinglePage = true
        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.centerX.equalToSuperview()
        }
    }

    private func setupCarousel() {
        scrollView.clearSubviews()
        imageViews.removeAll()
        pageControl.numberOfPages = imageUrls.count
        pageControl.isHidden = imageUrls.count <= 1
        timer?.invalidate()

        guard !imageUrls.isEmpty else { return }

        var previousImageView: UIImageView? = nil
        for url in imageUrls {
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            imageView.kf.setImage(with: URL(string: url))
            scrollView.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.width.height.equalToSuperview()
                $0.leading.equalTo(previousImageView?.snp.trailing ?? scrollView.snp.leading)
                $0.top.bottom.equalToSuperview()
            }
            previousImageView = imageView
        }

        previousImageView?.snp.makeConstraints { $0.trailing.equalToSuperview() }

        setupAutoSlide()
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
        let nextPage = (pageControl.currentPage + 1) % imageUrls.count
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
        timer?.invalidate()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setupAutoSlide()
    }
}
