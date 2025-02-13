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
    private var isSearchBarVisible = false
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        configureInitialVisibility()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        addSubviews(scrollView, searchBarView, topFixedFrame)
        scrollView.addSubview(carouselView)
        topFixedFrame.searchIconButton.addTarget(self, action: #selector(toggleSearchBar), for: .touchUpInside)
    }
    
    private func configureSearchBarView() {
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
        
        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        carouselView.snp.makeConstraints { make in
            make.top.equalTo(categoryFilterView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
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
    
    @objc func hideKeyboard() {
        searchBarView.searchTextField.resignFirstResponder()
    }
    
    func toggleVisibility(viewToShow: UIView, viewToHide: UIView) {
        UIView.animate(withDuration: 0.3) {
            viewToHide.alpha = 0
            viewToShow.alpha = 1
        } completion: { _ in
            viewToHide.isHidden = true
            viewToShow.isHidden = false
            
            self.bringSubviewToFront(viewToShow)
        }
    }
    
    private func configureInitialVisibility() {
        topFixedFrame.alpha = 1
        searchBarView.alpha = 0
        isSearchBarVisible = false
    }
    
    // MARK: - Visibility Toggle Methods
    func toggleToSearchBar() {
        guard !isSearchBarVisible else { return }
        UIView.animate(withDuration: 0.1, animations: {
            self.topFixedFrame.alpha = 0
            self.searchBarView.alpha = 1
        }) { _ in
            self.topFixedFrame.isHidden = true
            self.searchBarView.isHidden = false
            self.searchBarView.searchTextField.becomeFirstResponder()
            self.isSearchBarVisible = true
        }
    }
    
    func toggleToTopFrame() {
        guard isSearchBarVisible else { return }
        UIView.animate(withDuration: 0.1, animations: {
            self.searchBarView.alpha = 0
            self.topFixedFrame.alpha = 1
        }) { _ in
            self.searchBarView.isHidden = true
            self.topFixedFrame.isHidden = false
            self.searchBarView.searchTextField.resignFirstResponder()
            self.isSearchBarVisible = false
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
