//
//  MyPageViewController.swift
//  Pricedive
//
//  Created by 신호연 on 12/26/24.
//

import UIKit
import Combine

class MyPageViewController: UIViewController, MyPageViewDelegate {
    private let myPageView = MyPageView()
    private let viewModel: MyPageViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var groupedProducts: [(String, [ViewedProduct])] = []

    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = myPageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        myPageView.delegate = self
        setupTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        viewModel.loadViewedProducts()
    }

    private func setupTableView() {
        myPageView.tableView.delegate = self
        myPageView.tableView.dataSource = self
        myPageView.tableView.separatorStyle = .none
        myPageView.tableView.backgroundColor = .clear

        // ✅ HeaderCell 등록 추가
        myPageView.tableView.register(HeaderCell.self, forCellReuseIdentifier: "HeaderCell")
        myPageView.tableView.register(LikeProductCell.self, forCellReuseIdentifier: "LikeProductCell")
    }

    private func bindViewModel() {
        viewModel.$groupedProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] groupedProducts in
                self?.groupedProducts = groupedProducts
                self?.myPageView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    func clearAllButtonTapped() {
        viewModel.clearAllViewedProducts()
        groupedProducts = []
        myPageView.tableView.reloadData()
    }
}

extension MyPageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedProducts.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedProducts[section].1.count + 1 // ✅ 첫 번째 헤더 셀을 추가했으므로 +1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 40 + 12 : 100 + 12 // ✅ 패딩 포함 (6+6)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            let dateText = groupedProducts[indexPath.section].0
            cell.configure(with: dateText)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LikeProductCell", for: indexPath) as! LikeProductCell
            let product = groupedProducts[indexPath.section].1[indexPath.row - 1]
            cell.configure(with: product.toEvent(), viewModel: viewModel.homeViewModel, style: .myPage)

            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .white
            cell.contentView.layer.cornerRadius = 12
            cell.contentView.layer.masksToBounds = true

            cell.selectionStyle = .none

            // ✅ 삭제 버튼이 눌렸을 때 해당 상품 삭제
            cell.onDelete = { [weak self] in
                self?.viewModel.deleteViewedProduct(product)
            }

            return cell
        }
    }

    /// ✅ 셀 간 간격을 12로 설정하기 위한 푸터 설정
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12) // ✅ 셀 간 간격 유지
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear // ✅ 푸터 배경을 clear로 설정하여 간격만 적용되도록 함
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // ✅ 선택 해제 애니메이션

        // ✅ 첫 번째 셀(헤더)은 클릭해도 아무 동작 없음
        if indexPath.row == 0 { return }

        let product = groupedProducts[indexPath.section].1[indexPath.row - 1] // ✅ row - 1 적용
        let event = product.toEvent() // ✅ ViewedProduct -> Event 변환

        // ✅ 상세 페이지로 이동
        let detailVC = EventDetailViewController(event: event, homeViewModel: viewModel.homeViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

class HeaderCell: UITableViewCell {
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label.textColor = UIColor.darkGray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with date: String) {
        dateLabel.text = date
    }

    private func setupLayout() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20) // ✅ 좌우 패딩 적용
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
}
