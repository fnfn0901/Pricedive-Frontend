//
//  LikeView.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import SnapKit

final class LikeView: UIView {
    // MARK: - UI Elements
    let topFixedFrameView = TopFixedFrameView()
    let searchBarView = SearchBarView()
    private var isSearchBarVisible = false
    
    let savedItemsLabel = UILabel.createCustomLabel(
        text: "찜한 상품",
        color: .white,
        font: UIFont(name: "Pretendard-Medium", size: 12)!,
        lineHeight: 1.0,
        kern: 0
    )
    let inProgressLabel = UILabel.createCustomLabel(
        text: "진행중",
        color: UIColor(hex: "#6B7280")!,
        font: UIFont(name: "Pretendard-Medium", size: 12)!,
        lineHeight: 1.0,
        kern: 0
    )
    
    private lazy var baseView = createRoundedView(cornerRadius: 8, backgroundColor: .mainWhite)
    private lazy var blueBox = createRoundedView(cornerRadius: 6, backgroundColor: .mainBlue)
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(LikeProductCell.self, forCellReuseIdentifier: "LikeProductCell")
        return tableView
    }()
    
    private var blueBoxLeadingConstraint: Constraint?

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupUI() {
        backgroundColor = .white
        addSubviews(topFixedFrameView, searchBarView, baseView, tableView)
        baseView.addSubviews(blueBox, savedItemsLabel, inProgressLabel)

        searchBarView.alpha = 0
        
        savedItemsLabel.textAlignment = .center
        inProgressLabel.textAlignment = .center

        setupConstraints()
    }

    private func setupConstraints() {
        topFixedFrameView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }

        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }

        baseView.snp.makeConstraints { make in
            make.top.equalTo(topFixedFrameView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(44)
        }

        blueBox.snp.makeConstraints { make in
            blueBoxLeadingConstraint = make.leading.equalTo(baseView.snp.leading).offset(4).constraint
            make.centerY.equalTo(baseView)
            make.height.equalTo(36)
            make.width.equalTo(155)
        }

        savedItemsLabel.snp.makeConstraints { make in
            make.leading.equalTo(baseView).offset(4)
            make.centerY.equalTo(baseView)
            make.width.equalTo(155)
        }

        inProgressLabel.snp.makeConstraints { make in
            make.trailing.equalTo(baseView).offset(-4)
            make.centerY.equalTo(baseView)
            make.width.equalTo(155)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(baseView.snp.bottom).offset(2)
            make.leading.trailing.bottom.equalToSuperview().inset(30)
        }
    }

    // MARK: - 검색 토글 기능 추가
    func toggleToSearchBar() {
        guard !isSearchBarVisible else { return }
        
        searchBarView.isHidden = false
        searchBarView.alpha = 0
        topFixedFrameView.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.topFixedFrameView.alpha = 0
            self.searchBarView.alpha = 1
        }) { _ in
            self.topFixedFrameView.isHidden = true
            self.searchBarView.searchTextField.becomeFirstResponder()
        }
        
        isSearchBarVisible = true
    }

    func toggleToTopFrame() {
        guard isSearchBarVisible else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.searchBarView.alpha = 0
            self.topFixedFrameView.alpha = 1
        }) { _ in
            self.searchBarView.isHidden = true
            self.topFixedFrameView.isHidden = false
            self.searchBarView.searchTextField.resignFirstResponder()
        }
        
        isSearchBarVisible = false
    }
    
    private func createRoundedView(cornerRadius: CGFloat, backgroundColor: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornerRadius
        return view
    }
    
    func animateBlueBox(to index: Int) {
        blueBoxLeadingConstraint?.update(offset: index == 0 ? 4 : 161)

        savedItemsLabel.textColor = index == 0 ? .white : UIColor(hex: "#6B7280")!
        inProgressLabel.textColor = index == 1 ? .white : UIColor(hex: "#6B7280")!

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
