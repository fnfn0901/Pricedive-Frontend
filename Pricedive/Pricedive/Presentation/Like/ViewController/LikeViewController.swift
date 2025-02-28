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
    
    // MARK: - Initializer
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        loadLikedEvents()
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
        
        likeView.topFixedFrameView.searchIconButton.addTarget(self, action: #selector(toggleSearchBar), for: .touchUpInside)
        likeView.searchBarView.xMarkButton.addTarget(self, action: #selector(toggleToTopFrame), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.$likedEventsList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] likedEvents in
                print("✅ TableView 업데이트: \(likedEvents.count)개의 좋아요한 이벤트")
                self?.likeView.tableView.isHidden = likedEvents.isEmpty
                self?.likeView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 검색 기능 토글
    @objc private func toggleSearchBar() {
        likeView.toggleToSearchBar()
    }
    
    @objc private func toggleToTopFrame() {
        likeView.toggleToTopFrame()
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
    
    private func loadLikedEvents() {
        viewModel.loadLikedEvents(ongoing: isOngoing)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.likeView.tableView.reloadData()
        }
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
    }
}

extension LikeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.likedEventsList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LikeProductCell", for: indexPath) as? LikeProductCell else {
            return UITableViewCell()
        }

        let eventDTO = viewModel.likedEventsList[indexPath.section]
        
        let event = Event(
            eventId: eventDTO.eventId,
            videoId: eventDTO.videoId,
            eventLink: "",
            eventImage: eventDTO.previewImg,
            youtuberProfileImage: "",
            eventEndDate: eventDTO.dateEnd,
            eventTitle: eventDTO.eventItem,
            eventDescription: nil,
            isLiked: true
        )

        cell.configure(with: event, viewModel: viewModel, style: .like)
        return cell
    }
}
