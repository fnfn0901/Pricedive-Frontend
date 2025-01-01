//
//  UIView+.swift
//  Pricedive
//
//  Created by 신호연 on 11/26/24.
//

import UIKit
import Kingfisher

extension UIView {
    
    // 유튜버 프로필 뷰 생성
    static func createYoutuberProfileView(
        imageUrl: String,
        cornerRadius: CGFloat = 20,
        borderColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15),
        borderWidth: CGFloat = 1,
        placeholderImage: UIImage? = UIImage(named: "defaultProfileImage")
    ) -> UIView {
        let profileView = UIView()
        profileView.layer.cornerRadius = cornerRadius
        profileView.layer.borderWidth = borderWidth
        profileView.layer.borderColor = borderColor.cgColor
        profileView.clipsToBounds = true

        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: imageUrl), placeholder: placeholderImage)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        profileView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return profileView
    }
    
    // 이미지 Aspect Fill로 Superview에 맞추기
    func fillWithImage(_ imageUrl: String) {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.kf.setImage(with: URL(string: imageUrl))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    // 디데이 뷰 생성
    static func createDDayView(
        text: String,
        backgroundColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.60)
    ) -> UIView {
        let dDayView = UIView()
        dDayView.translatesAutoresizingMaskIntoConstraints = false
        dDayView.layer.backgroundColor = backgroundColor.cgColor
        dDayView.clipsToBounds = true

        let label = UILabel.createCustomLabel(
            text: "\(text)",
            color: UIColor.mainRed,
            font: UIFont(name: "Pretendard-Bold", size: 16)!,
            lineHeight: 0,
            kern: 1.5
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        dDayView.addSubview(label)

        label.centerXAnchor.constraint(equalTo: dDayView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: dDayView.centerYAnchor).isActive = true

        return dDayView
    }
    
    func clearSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func addArrangedSubviewWithSpacing(_ subview: UIView, index: Int) {
        addSubview(subview)
        subview.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(index == 0 ? self.snp.top : self.subviews[index - 1].snp.bottom)
        }
    }
}
