//
//  LikeViewController.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit
import Combine
import SnapKit

final class LikeViewController: UIViewController {
    private let likeView = LikeView()
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    private var isOngoing: Bool = false
    
    private var likedEvents: [LikedEventDTO] = []
    
    // MARK: - Initializer
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        loadLikedEvents()
        viewModel.loadLikedEvents(ongoing: isOngoing)
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = likeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupActions()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        likeView.tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        likeView.tableView.setContentOffset(CGPoint(x: 0, y: -12), animated: false)
    }
    
    // MARK: - Setup Methods
    private func setupTableView() {
        likeView.tableView.delegate = self
        likeView.tableView.dataSource = self
        likeView.tableView.separatorStyle = .none
    }
    
    private func setupActions() {
        likeView.savedItemsLabel.isUserInteractionEnabled = true
        likeView.inProgressLabel.isUserInteractionEnabled = true
        
        let savedTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSavedItems))
        likeView.savedItemsLabel.addGestureRecognizer(savedTapGesture)
        
        let inProgressTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapInProgress))
        likeView.inProgressLabel.addGestureRecognizer(inProgressTapGesture)
    }
    
    private func bindViewModel() {
        viewModel.$likedEventsList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] likedEvents in
                self?.likeView.tableView.isHidden = likedEvents.isEmpty
                self?.likeView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func loadLikedEvents() {
        viewModel.loadLikedEvents(ongoing: isOngoing)
    }
    
    // MARK: - Actions
    @objc private func didTapSavedItems() {
        isOngoing = false
        likeView.animateBlueBox(to: 0)
        loadLikedEvents()
    }
    
    @objc private func didTapInProgress() {
        isOngoing = true
        likeView.animateBlueBox(to: 1)
        loadLikedEvents()
    }
}

// MARK: - UITableViewDelegate
extension LikeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let likedEventDTO = viewModel.likedEventsList[indexPath.section]
        let eventId = likedEventDTO.eventId

        print("✅ 선택된 이벤트 ID: \(eventId), 데이터 요청 중...")

        APIManager.shared.fetchEventDetail(eventId: eventId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let eventDTO):
                    let event = eventDTO.toEvent()
                    let detailVC = EventDetailViewController(event: event, homeViewModel: self?.viewModel ?? HomeViewModel())
                    self?.navigationController?.pushViewController(detailVC, animated: true)
                    
                case .failure(let error):
                    print("❌ 이벤트 상세 정보 가져오기 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension LikeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = viewModel.likedEventsList.count
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LikeProductCell", for: indexPath) as? LikeProductCell else {
            print("❌ 셀 등록 오류: LikeProductCell")
            return UITableViewCell()
        }

        let likedEventDTO = viewModel.likedEventsList[indexPath.section]
        let event = likedEventDTO.toEvent()

        cell.configure(with: event, viewModel: viewModel, style: .like)
        
        return cell
    }
}
