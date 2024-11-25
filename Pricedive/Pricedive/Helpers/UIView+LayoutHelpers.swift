//
//  UIView+LayoutHelpers.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

extension UIView {
    func addCustomLabel(
        label: UILabel,
        width: CGFloat,
        height: CGFloat,
        leading: CGFloat,
        top: CGFloat
    ) {
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.heightAnchor.constraint(equalToConstant: height).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leading).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: top).isActive = true
    }
}
