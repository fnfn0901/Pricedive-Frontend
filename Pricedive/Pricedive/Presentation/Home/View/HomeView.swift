//
//  HomeView.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

class HomeView: BaseView {
    let topFixedFrame = TopFixedFrameView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTopFixedFrame()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTopFixedFrame() {
        addSubview(topFixedFrame)
        topFixedFrame.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }

        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(topFixedFrame.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
