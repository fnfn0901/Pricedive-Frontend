//
//  MyPageViewController.swift
//  Pricedive
//
//  Created by 신호연 on 12/26/24.
//

import UIKit
import Combine

class MyPageViewController: UIViewController {
    private let myPageView = MyPageView()
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: HomeViewModel) {
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
        setupNavigationBar()
        bindViewModel()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }

    private func bindViewModel() {
        viewModel.$events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] events in
                self?.populateSections(with: events)
            }
            .store(in: &cancellables)
    }

    private func populateSections(with events: [Event]) {
        let groupedEvents = groupEventsByDate(events)
        
        groupedEvents.forEach { (title, events) in
            let cells = events.map { event -> UIView in
                let cell = LikeProductCell()
                cell.configure(with: event, style: .myPage)
                return cell
            }
            myPageView.addSection(title: title, cells: cells)
        }
    }

    private func groupEventsByDate(_ events: [Event]) -> [(String, [Event])] {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!

        var todayEvents = [Event]()
        var yesterdayEvents = [Event]()
        var thisWeekEvents = [Event]()

        events.forEach { event in
            if calendar.isDate(event.eventEndDate, inSameDayAs: today) {
                todayEvents.append(event)
            } else if calendar.isDate(event.eventEndDate, inSameDayAs: yesterday) {
                yesterdayEvents.append(event)
            } else if event.eventEndDate >= startOfWeek {
                thisWeekEvents.append(event)
            }
        }

        return [
            ("오늘", todayEvents),
            ("어제", yesterdayEvents),
            ("이번 주", thisWeekEvents)
        ].filter { !$0.1.isEmpty }
    }
}
