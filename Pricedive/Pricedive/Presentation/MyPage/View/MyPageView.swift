//
//  MyPageView.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit
import SnapKit

class MyPageView: UIView {
    let topFixedFrameView: TopFixedFrameView = {
        let view = TopFixedFrameView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        // Subviews 추가
        addSubview(topFixedFrameView)
        
        // SnapKit 제약 조건
        topFixedFrameView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
    }
}
