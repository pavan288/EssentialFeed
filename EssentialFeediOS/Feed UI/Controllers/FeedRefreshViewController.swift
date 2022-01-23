//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Pavan Powani on 21/01/22.
//

import UIKit

public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    private(set) lazy var view = loadView()

    private let feedPresenter: FeedPresenter

    init(feedPresenter: FeedPresenter) {
        self.feedPresenter = feedPresenter
    }

    func display(isLoading: Bool) {
        if isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }

    @objc
    func refresh() {
        feedPresenter.loadFeed()
    }

    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
