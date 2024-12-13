//
//  SearchBarView.swift
//  Pricedive
//
//  Created by 신호연 on 12/13/24.
//

import UIKit
import SnapKit

class SearchBarView: UIView {
    
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
            target: nil,
            action: nil
        )
        button.tintColor = .placeholderGray
        return button
    }()

    lazy var xMarkButton: UIButton = {
        let button = UIButton.createIconButton(
            image: UIImage(systemName: "xmark"),
            target: nil,
            action: nil
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSearchBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSearchBar() {
        addSubview(searchContainerView)
        searchContainerView.addSubview(magnifyingGlassButton)
        searchContainerView.addSubview(searchTextField)
        searchContainerView.addSubview(xMarkButton)

        searchContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(48)
        }

        magnifyingGlassButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(24)
        }

        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(magnifyingGlassButton.snp.trailing).offset(12)
            make.trailing.equalTo(xMarkButton.snp.leading).offset(-12)
        }
        searchTextField.isUserInteractionEnabled = true
        
        xMarkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
            make.width.height.equalTo(24)
        }
    }
}
