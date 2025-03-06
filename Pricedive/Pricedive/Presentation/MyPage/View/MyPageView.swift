//
//  MyPageView.swift
//  Pricedive
//
//  Created by 신호연 on 12/26/24.
//

import UIKit
import SnapKit

protocol MyPageViewDelegate: AnyObject {
    func clearAllButtonTapped()
}

class MyPageView: UIView {
    weak var delegate: MyPageViewDelegate?

    let navigationBarLabel: UILabel = {
        let label = CustomStyles.navigationText()
        label.text = "최근 본 상품"
        return label
    }()

    let clearAllLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 삭제"
        label.textColor = UIColor.placeholderGray
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.isUserInteractionEnabled = true
        return label
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(hex: "F9FAFB")
        tableView.register(LikeProductCell.self, forCellReuseIdentifier: "LikeProductCell")
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubviews(navigationBarLabel, clearAllLabel, tableView)
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

        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clearAllTapped))
        clearAllLabel.addGestureRecognizer(tapGesture)
    }

    @objc private func clearAllTapped() {
        delegate?.clearAllButtonTapped()
    }
}
