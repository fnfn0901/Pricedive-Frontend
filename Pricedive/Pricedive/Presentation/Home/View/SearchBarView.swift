//
//  SearchBarView.swift
//  Pricedive
//
//  Created by 신호연 on 12/13/24.
//

import UIKit
import SnapKit

class SearchBarView: UIView, UITextFieldDelegate {
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "검색어를 입력하세요..."
        textField.font = UIFont(name: "NotoSans-Regular", size: 14)
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "검색어를 입력하세요...",
            attributes: [
                .foregroundColor: UIColor.placeholderGray,
                .font: UIFont(name: "NotoSans-Regular", size: 14)!
            ]
        )
        textField.borderStyle = .none
        return textField
    }()

    lazy var magnifyingGlassButton: UIButton = {
        let button = UIButton.createIconButton(
            image: UIImage(systemName: "magnifyingglass"),
            target: self,
            action: #selector(handleMagnifyingGlassClick)
        )
        button.tintColor = .placeholderGray
        return button
    }()

    lazy var xMarkButton: UIButton = {
        let button = UIButton.createIconButton(
            image: UIImage(systemName: "xmark"),
            target: self,
            action: #selector(handleXMarkClick)
        )
        button.tintColor = .mainBlue
        return button
    }()
    
    private let searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainWhite
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        return view
    }()

    var onCancelTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSearchBar()
        searchTextField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSearchBar() {
        configureSearchContainer()
        configureButtons()
        configureTextField()
        xMarkButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
    }

    private func configureSearchContainer() {
        addSubview(searchContainerView)
        searchContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(48)
        }
    }

    private func configureButtons() {
        searchContainerView.addSubviews(magnifyingGlassButton, xMarkButton)

        magnifyingGlassButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.width.equalTo(24)
        }

        xMarkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
            make.width.height.equalTo(24)
        }
    }

    private func configureTextField() {
        searchContainerView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(magnifyingGlassButton.snp.trailing).offset(12)
            make.trailing.equalTo(xMarkButton.snp.leading).offset(-12)
        }
        searchTextField.isUserInteractionEnabled = true
        searchTextField.returnKeyType = .search
    }

    @objc private func handleMagnifyingGlassClick() {
        searchTextField.resignFirstResponder()
    }

    @objc private func handleXMarkClick() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        if let homeView = self.superview as? HomeView {
            homeView.resetToTopFixedFrame()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func didTapCancel() {
        onCancelTapped?()
    }
}
