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
        setupNavigationBar()
        setupTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadViewedProducts()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }

    private func setupTableView() {
        myPageView.tableView.delegate = self
        myPageView.tableView.dataSource = self
        myPageView.tableView.separatorStyle = .none
        myPageView.tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
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
        return groupedProducts[section].1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeProductCell", for: indexPath) as! LikeProductCell
        let product = groupedProducts[indexPath.section].1[indexPath.row]
        cell.configure(with: product.toEvent(), viewModel: viewModel.homeViewModel, style: .myPage)
        return cell
    }

    /// ✅ 섹션 헤더 (날짜 구분 유지)
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(hex: "F9FAFB")

        let label = UILabel()
        label.text = groupedProducts[section].0
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label.textColor = UIColor.darkGray

        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    /// ✅ 셀 간격 추가 (LikeViewController와 동일)
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
}
