//
//  HomeView.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import SnapKit

class HomeView: UIView {

    // MARK: - Properties

    let topFixedFrame = TopFixedFrameView()
    let scrollView = UIScrollView()
    let categoryFilterView = CategoryFilterView()
    let carouselView = CarouselView()
    let eventProductView = EventProductView()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup Methods

    private func setupView() {
        setupTopFixedFrame()
        setupScrollView()
        setupScrollContent()
    }

    private func setupTopFixedFrame() {
        addSubview(topFixedFrame)
        topFixedFrame.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
    }

    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(topFixedFrame.snp.bottom).offset(17)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }

    private func setupScrollContent() {
        scrollView.addSubview(categoryFilterView)
        categoryFilterView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview()
        }

        scrollView.addSubview(carouselView)
        carouselView.snp.makeConstraints { make in
            make.top.equalTo(categoryFilterView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalToSuperview()
        }

        scrollView.addSubview(eventProductView)
        eventProductView.snp.makeConstraints { make in
            make.top.equalTo(carouselView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(10)
        }
    }
}

