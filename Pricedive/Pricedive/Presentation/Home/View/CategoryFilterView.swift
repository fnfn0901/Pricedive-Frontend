//
//  CategoryFilterView.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import SnapKit
import Combine

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

    private var cancellables = Set<AnyCancellable>()
    private var viewModel: CategoryViewModel?

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

    private func updateCategoryButtons(with categories: [Category]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        categories.forEach { category in
            let button = UIButton.createUnselectedCategoryButton(title: category.name)
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        
        layoutIfNeeded()
        adjustFirstAndLastButtonConstraints()
    }

    private func adjustFirstAndLastButtonConstraints() {
        guard !stackView.arrangedSubviews.isEmpty else { return }
        
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
            let isSelected = (button == selectedButton)
            button.layer.backgroundColor = isSelected ? UIColor.mainBlue.cgColor : UIColor.mainWhite.cgColor
            button.setTitleColor(isSelected ? .mainWhite : .mainBlack, for: .normal)
        }
    }

    // MARK: - Public Methods
    func bind(to viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        viewModel.$categories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                self?.updateCategoryButtons(with: categories)
            }
            .store(in: &cancellables)
        
        updateCategoryButtons(with: viewModel.categories)
    }
}
