//
//  EventProductView.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

class EventProductView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .brown
    }
}
