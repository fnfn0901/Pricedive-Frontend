//
//  UIButton+Animation.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit

extension UIButton {
    // 버튼 클릭 애니메이션
    func animateNaturalTouch(completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.1,
                    delay: 0,
                    options: [.curveEaseIn],
                    animations: {
                        self.transform = .identity
                    },
                    completion: { _ in
                        completion?()
                    }
                )
            }
        )
    }
}
