//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Pavan Powani on 21/01/22.
//

import UIKit

public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    private(set) lazy var view = loadView()

    private let loadFeed: () -> Void

    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }

    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }

    @objc
    func refresh() {
        loadFeed()
    }

    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
