//
//  CategoryFilterView.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import SnapKit

class CategoryFilterView: UIView {

    // MARK: - Properties

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return stackView
    }()

    private var categories: [String] = ["의류", "가방", "전자기기", "뷰티"]

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupCategories()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupCategories()
    }

    // MARK: - Setup Methods

    private func setupView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }

    private func setupCategories() {
        updateCategoryButtons(with: categories)
    }

    private func updateCategoryButtons(with categories: [String]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for category in categories {
            let button = UIButton.createUnselectedCategoryButton(title: category)
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }

        adjustFirstAndLastButtonConstraints()
    }

    private func adjustFirstAndLastButtonConstraints() {
        if let firstButton = stackView.arrangedSubviews.first {
            firstButton.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
            }
        }

        if let lastButton = stackView.arrangedSubviews.last {
            lastButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-20)
            }
        }
    }

    // MARK: - Button Actions

    @objc private func categoryButtonTapped(_ sender: UIButton) {
        guard sender.title(for: .normal) != nil else { return }

        sender.animateNaturalTouch { [weak self] in
            self?.updateButtonStyles(selectedButton: sender)
        }
    }

    private func updateButtonStyles(selectedButton: UIButton) {
        stackView.arrangedSubviews.forEach {
            guard let button = $0 as? UIButton else { return }
            if button == selectedButton {
                button.layer.backgroundColor = UIColor.mainBlue.cgColor
                button.setTitleColor(.mainWhite, for: .normal)
            } else {
                button.layer.backgroundColor = UIColor.mainWhite.cgColor
                button.setTitleColor(.mainBlack, for: .normal)
            }
        }
    }

    // MARK: - Public Methods

    func updateCategories(_ newCategories: [String]) {
        categories = newCategories
        updateCategoryButtons(with: newCategories)
    }
}
