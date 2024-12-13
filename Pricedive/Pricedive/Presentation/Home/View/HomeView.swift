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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTopFixedFrame()
        setupCarouselView()
        setupSearchBarView()
        setupConstraints()
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
        
        topFixedFrame.searchIconButton.addTarget(self, action: #selector(toggleSearchBar), for: .touchUpInside)
    }

    private func setupCarouselView() {
        contentView.addSubview(carouselView)
        carouselView.snp.makeConstraints { make in
            make.top.equalTo(categoryFilterView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
    }

    private func setupSearchBarView() {
        addSubview(searchBarView)
        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        searchBarView.alpha = 0
        
        searchBarView.searchTextField.delegate = self
        
        scrollView.keyboardDismissMode = .onDrag
    }

    private func setupConstraints() {
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(topFixedFrame.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.updateConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        categoryFilterView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }

        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(carouselView.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    @objc private func toggleSearchBar() {
        self.topFixedFrame.alpha = 0
        self.searchBarView.alpha = 1
        searchBarView.searchTextField.becomeFirstResponder()
    }
    
    @objc func resetToTopFixedFrame() {
        searchBarView.searchTextField.text = ""
        hideKeyboard()
        self.topFixedFrame.alpha = 1
        self.searchBarView.alpha = 0
    }
    
    @objc private func hideKeyboard() {
        searchBarView.searchTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
   }
}
