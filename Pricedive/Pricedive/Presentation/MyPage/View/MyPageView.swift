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

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(hex: "F9FAFB")
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    let contentView = UIView()

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
        addSubviews(navigationBarLabel, clearAllLabel, scrollView)
        scrollView.addSubview(contentView)
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

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clearAllTapped))
        clearAllLabel.addGestureRecognizer(tapGesture)
    }

    @objc private func clearAllTapped() {
        delegate?.clearAllButtonTapped()
    }

    func addSection(title: String, cells: [UIView]) {
        let sectionLabel = UILabel()
        sectionLabel.text = title
        sectionLabel.font = UIFont(name: "Pretendard-Medium", size: 12)
        sectionLabel.textColor = UIColor.placeholderGray

        contentView.addSubview(sectionLabel)
        sectionLabel.snp.makeConstraints { make in
            if let lastSubview = contentView.subviews.last(where: { $0 !== sectionLabel }) {
                make.top.equalTo(lastSubview.snp.bottom).offset(16)
            } else {
                make.top.equalToSuperview().offset(16)
            }
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        var previousCell: UIView?
        for cell in cells {
            contentView.addSubview(cell)
            cell.snp.makeConstraints { make in
                make.top.equalTo(previousCell?.snp.bottom ?? sectionLabel.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview().inset(16)
            }
            previousCell = cell
        }

        if let lastCell = cells.last {
            lastCell.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-16).priority(.low)
            }
        }
    }
}
