//
//  FeedViewControllerTest+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Pavan Powani on 21/01/22.
//

import EssentialFeediOS
import UIKit

extension FeedViewController {
    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
        return feedImageView(at: index) as? FeedImageCell
    }

    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewVisible(at: row)

        let delegate = tableView.delegate
        let indexPath = IndexPath(row: row, section: feedImageSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: indexPath)
        return view
    }

    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }

    func simulateUserInitiatedFeedReload() {
        self.refreshControl?.simulatePullToRefresh()
    }

    func numberOfRenderedFeedImageViews() -> Int {
        return tableView.numberOfRows(inSection: feedImageSection)
    }

    private var feedImageSection: Int {
        return 0
    }

    func feedImageView(at row: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource
        let indexPath = IndexPath(row: row, section: feedImageSection)
        return dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }

    func simulateFeedImageViewNearVisible(at row: Int) {
        let dataSource = tableView.prefetchDataSource
        let indexPath = IndexPath(row: row, section: feedImageSection)
        dataSource?.tableView(tableView, prefetchRowsAt: [indexPath])
    }

    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageViewNearVisible(at: row)

        let dataSource = tableView.prefetchDataSource
        let indexPath = IndexPath(row: row, section: feedImageSection)
        dataSource?.tableView?(tableView, cancelPrefetchingForRowsAt: [indexPath])
    }
}
