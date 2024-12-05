//
//  SearchView.swift
//  Pricedive
//
//  Created by 신호연 on 12/6/24.
//

import UIKit
import SnapKit

class SearchView: UIView {

    // MARK: - Properties
    private let searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainWhite
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        return view
    }()
    
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
    
    private let magnifyingGlassIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .placeholderGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let xMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .mainBlue
        return button
    }()
    
    let categoryFilterView = CategoryFilterView()
    
    let collectionView: UICollectionView

    // MARK: - Initializers
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 160, height: 173)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .white
        addSubview(searchContainerView)
        searchContainerView.addSubview(magnifyingGlassIcon)
        searchContainerView.addSubview(searchTextField)
        searchContainerView.addSubview(xMarkButton)
        addSubview(categoryFilterView)
        addSubview(collectionView)
        
        collectionView.backgroundColor = .white
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: "EventProductCell")
    }
    
    private func setupConstraints() {
        // 검색바 컨테이너
        searchContainerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(9)
            make.height.equalTo(48)
        }
        
        // 돋보기 아이콘
        magnifyingGlassIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.width.height.equalTo(24)
        }
        
        // 검색 텍스트 필드
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(magnifyingGlassIcon.snp.trailing).offset(12)
            make.trailing.equalTo(xMarkButton.snp.leading).offset(-12)
        }
        
        // X마크 버튼
        xMarkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
            make.width.height.equalTo(24)
        }
        
        // 필터 뷰
        categoryFilterView.snp.makeConstraints { make in
            make.top.equalTo(searchContainerView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        // 컬렉션 뷰
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryFilterView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}
