//
//  EventDetailViewController.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import UIKit

class EventDetailViewController: UIViewController {
    private let event: Event

    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
