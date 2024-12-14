//
//  SearchView.swift
//  Pricedive
//
//  Created by 신호연 on 12/6/24.
//

import UIKit
import SnapKit

class SearchView: BaseView {

    let searchBarView = SearchBarView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSearchBarView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSearchBarView() {
        addSubview(searchBarView)
        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }

        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(searchBarView.snp.bottom).offset(6)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
