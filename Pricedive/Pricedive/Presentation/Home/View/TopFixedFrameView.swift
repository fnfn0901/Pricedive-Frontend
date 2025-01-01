//
//  TopFixedFrameView.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit
import SnapKit

class TopFixedFrameView: UIView {

    // MARK: - Properties

    private let logoLabel: UILabel = CustomStyles.logoText()

    let searchIconButton: UIButton = {
        let image = UIImage(systemName: "magnifyingglass")
        return UIButton.createIconButton(image: image, target: nil, action: nil)
    }()

    func setSearchButtonTarget(target: Any?, action: Selector) {
        searchIconButton.addTarget(target, action: action, for: .touchUpInside)
    }

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

        addSubview(logoLabel)
        logoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        addSubview(searchIconButton)
        searchIconButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
