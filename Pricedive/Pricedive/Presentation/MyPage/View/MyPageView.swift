//
//  MyPageView.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit
import SnapKit

class MyPageView: UIView {
    // MARK: - UI Elements
    let topFixedFrameView = TopFixedFrameView()
    
    private lazy var baseView: UIView = {
        createRoundedView(cornerRadius: 8, backgroundColor: .mainWhite)
    }()
    
    private lazy var blueBox: UIView = {
        createRoundedView(cornerRadius: 6, backgroundColor: .mainBlue)
    }()
    
    let savedItemsLabel: UILabel = UILabel.createCustomLabel(
        text: "찜한 상품",
        color: .white,
        font: UIFont(name: "Pretendard-Medium", size: 12)!,
        lineHeight: 1.0,
        kern: 0
    )
    
    let inProgressLabel: UILabel = UILabel.createCustomLabel(
        text: "진행중",
        color: UIColor(hex: "#6B7280")!,
        font: UIFont(name: "Pretendard-Medium", size: 12)!,
        lineHeight: 1.0,
        kern: 0
    )
    
    private var blueBoxLeadingConstraint: Constraint?

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .white
        
        // Add subviews
        addSubview(topFixedFrameView)
        addSubview(baseView)
        baseView.addSubview(blueBox)
        baseView.addSubview(savedItemsLabel)
        baseView.addSubview(inProgressLabel)
        
        savedItemsLabel.textAlignment = .center
        inProgressLabel.textAlignment = .center
        
        // Layout subviews
        setupConstraints()
    }
    
    private func setupConstraints() {
        // Top fixed frame view
        topFixedFrameView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        
        // Base view
        baseView.snp.makeConstraints { make in
            make.top.equalTo(topFixedFrameView.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(44)
        }
        
        // Blue box
        blueBox.snp.makeConstraints { make in
            blueBoxLeadingConstraint = make.leading.equalTo(baseView.snp.leading).offset(4).constraint
            make.centerY.equalTo(baseView)
            make.height.equalTo(36)
            make.width.equalTo(155)
        }
        
        // Labels
        savedItemsLabel.snp.makeConstraints { make in
            make.leading.equalTo(baseView.snp.leading).offset(4)
            make.centerY.equalTo(baseView)
            make.height.equalTo(36)
            make.width.equalTo(155)
        }
        
        inProgressLabel.snp.makeConstraints { make in
            make.trailing.equalTo(baseView.snp.trailing).offset(-4)
            make.centerY.equalTo(baseView)
            make.height.equalTo(36)
            make.width.equalTo(155)
        }
    }
    
    // MARK: - Animations
    func animateBlueBox(to index: Int) {
        let newLeadingOffset: CGFloat = index == 0 ? 4 : 161
        blueBoxLeadingConstraint?.update(offset: newLeadingOffset)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        })
        
        updateLabelColors(selectedIndex: index)
    }
    
    // MARK: - Helpers
    private func updateLabelColors(selectedIndex: Int) {
        savedItemsLabel.textColor = selectedIndex == 0 ? .white : UIColor(hex: "#6B7280")!
        inProgressLabel.textColor = selectedIndex == 0 ? UIColor(hex: "#6B7280")! : .white
    }
    
    private func createRoundedView(cornerRadius: CGFloat, backgroundColor: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornerRadius
        return view
    }
}
