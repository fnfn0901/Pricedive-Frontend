//
//  UIView+Extension.swift
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
        size: CGFloat = 36.31,
        cornerRadius: CGFloat = 20,
        borderColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15),
        borderWidth: CGFloat = 1
    ) -> UIView {
        let profileView = UIView()
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.widthAnchor.constraint(equalToConstant: size).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: size).isActive = true
        
        profileView.layer.cornerRadius = cornerRadius
        profileView.layer.borderWidth = borderWidth
        profileView.layer.borderColor = borderColor.cgColor
        profileView.clipsToBounds = true
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.kf.setImage(with: URL(string: imageUrl))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        profileView.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: profileView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: profileView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: profileView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: profileView.bottomAnchor).isActive = true
        
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
        backgroundColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.60),
        size: CGSize = CGSize(width: 54, height: 29)
    ) -> UIView {
        let dDayView = UIView()
        dDayView.translatesAutoresizingMaskIntoConstraints = false
        dDayView.layer.backgroundColor = backgroundColor.cgColor
        dDayView.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        dDayView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        dDayView.clipsToBounds = true
        
        let label = UILabel.createCustomLabel(
            text: "D-\(text)",
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
}
