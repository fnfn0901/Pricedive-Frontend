//
//  UIView+LayoutHelpers.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import UIKit

extension UIView {
    func addSubviewWithConstraints(
        subview: UIView,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        leading: CGFloat? = nil,
        top: CGFloat? = nil
    ) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false

        if let width = width {
            subview.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let leading = leading {
            subview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leading).isActive = true
        }
        if let top = top {
            subview.topAnchor.constraint(equalTo: self.topAnchor, constant: top).isActive = true
        }
    }
}
