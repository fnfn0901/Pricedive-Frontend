//
//  MyPageView.swift
//  Pricedive
//
//  Created by 신호연 on 12/26/24.
//

import UIKit
import SnapKit

class MyPageView: UIView {
    let navigationBarLabel: UILabel = {
        let label = CustomStyles.navigationText()
        label.text = "최근 본 상품"
        return label
    }()
    
    let clearAllLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 삭제"
        label.textColor = UIColor(named: "PlaceholderGray")
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(hex: "F9FAFB")
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubviews(navigationBarLabel, clearAllLabel, scrollView)
    }
    
    private func setupConstraints() {
        navigationBarLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }
        
        clearAllLabel.snp.makeConstraints { make in
            make.centerY.equalTo(navigationBarLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
