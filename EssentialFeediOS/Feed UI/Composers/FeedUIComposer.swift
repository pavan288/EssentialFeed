//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Pavan Powani on 21/01/22.
//

import EssentialFeed
import UIKit

public final class FeedUIComposer {
    private init() {}

    public static func feedComposedWith(loader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let feedPresenter = FeedPresenter(feedLoader: loader)
        let refreshController = FeedRefreshViewController(feedPresenter: feedPresenter)
        let feedController = FeedViewController(refreshController: refreshController)
        feedPresenter.loadingView = WeakRefProxy(refreshController)
        feedPresenter.feedView = FeedViewAdapter(loader: imageLoader, controller: feedController)
        return feedController
    }

    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                let viewModel = FeedImageViewModel(model: model, imageLoader: loader, imageTransformer: UIImage.init)
                return FeedImageCellController(viewModel: viewModel)
            }
        }
    }
}

private final class WeakRefProxy<T: AnyObject> {
    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefProxy: FeedLoadingView where T: FeedLoadingView {
    func display(isLoading: Bool) {
        object?.display(isLoading: isLoading)
    }
}

private final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let loader: FeedImageDataLoader

    init(loader: FeedImageDataLoader, controller: FeedViewController) {
        self.loader = loader
        self.controller = controller
    }

    func display(feed: [FeedImage]) {
        controller?.tableModel = feed.map { model in
            let viewModel = FeedImageViewModel(model: model, imageLoader: loader, imageTransformer: UIImage.init)
            return FeedImageCellController(viewModel: viewModel)
        }
    }
}
