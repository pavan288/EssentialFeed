//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Pavan Powani on 25/01/22.
//

import EssentialFeed
import Foundation

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
    private let feedLoader: FeedLoader
    var feedPresenter: FeedPresenter?

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func didRequestFeedRefresh() {
        feedPresenter?.didStartLoadingFeed()

        feedLoader.load { [weak self] result in
            switch result {
            case .success(let feed):
                self?.feedPresenter?.didFinishLoadingFeed(with: feed)
            case .failure(let error):
                self?.feedPresenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
}
