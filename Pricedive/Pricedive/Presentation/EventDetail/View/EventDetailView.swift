//
//  EventDetailView.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit
import SnapKit

class EventDetailView: UIView {

    let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let logoLabel: UILabel = CustomStyles.logoText()

    let backIconButton: UIButton = {
        let image = UIImage(systemName: "chevron.backward")
        return UIButton.createIconButton(image: image, target: nil, action: nil)
    }()

    let searchIconButton: UIButton = {
        let image = UIImage(systemName: "magnifyingglass")
        return UIButton.createIconButton(image: image, target: nil, action: nil)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(navigationBar)
        navigationBar.addSubview(logoLabel)
        navigationBar.addSubview(backIconButton)
        navigationBar.addSubview(searchIconButton)

        setupConstraints()
    }

    private func setupConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }

        logoLabel.snp.makeConstraints { make in
            make.center.equalTo(navigationBar)
        }

        backIconButton.snp.makeConstraints { make in
            make.leading.equalTo(navigationBar).offset(20)
            make.centerY.equalTo(navigationBar)
        }

        searchIconButton.snp.makeConstraints { make in
            make.trailing.equalTo(navigationBar).offset(-20)
            make.centerY.equalTo(navigationBar)
        }
    }
}
