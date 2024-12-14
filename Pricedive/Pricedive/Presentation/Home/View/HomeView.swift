//
//  HomeView.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

class HomeView: BaseView, UITextFieldDelegate {
    let topFixedFrame = TopFixedFrameView()
    let carouselView = CarouselView()
    let searchBarView = SearchBarView()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupUI() {
        configureTopFixedFrame()
        configureCarouselView()
        configureSearchBarView()
    }

    private func configureTopFixedFrame() {
        addSubview(topFixedFrame)
        topFixedFrame.searchIconButton.addTarget(self, action: #selector(toggleSearchBar), for: .touchUpInside)
    }

    private func configureCarouselView() {
        contentView.addSubview(carouselView)
    }

    private func configureSearchBarView() {
        addSubview(searchBarView)
        searchBarView.alpha = 0
        searchBarView.searchTextField.delegate = self
        scrollView.keyboardDismissMode = .onDrag
    }

    private func setupConstraints() {
        topFixedFrame.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }

        carouselView.snp.makeConstraints { make in
            make.top.equalTo(categoryFilterView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }

        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }

        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(topFixedFrame.snp.bottom).offset(2)
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.updateConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        categoryFilterView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }

        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(carouselView.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
    }

    // MARK: - Actions
    @objc private func toggleSearchBar() {
        toggleVisibility(viewToShow: searchBarView, viewToHide: topFixedFrame)
        searchBarView.searchTextField.becomeFirstResponder()
    }

    @objc func resetToTopFixedFrame() {
        searchBarView.searchTextField.text = ""
        hideKeyboard()
        toggleVisibility(viewToShow: topFixedFrame, viewToHide: searchBarView)
    }

    @objc private func hideKeyboard() {
        searchBarView.searchTextField.resignFirstResponder()
    }

    private func toggleVisibility(viewToShow: UIView, viewToHide: UIView) {
        viewToHide.alpha = 0
        viewToShow.alpha = 1
        self.layoutIfNeeded()
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
