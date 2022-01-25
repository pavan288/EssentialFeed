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
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: MainQueueDispatchDecorator(decoratee: loader))
        let feedController = FeedViewController.makeWith(delegate: presentationAdapter, title: FeedPresenter.title)
        presentationAdapter.feedPresenter = FeedPresenter(
            feedView: FeedViewAdapter(
                loader: MainQueueDispatchDecorator(decoratee: imageLoader),
                controller: feedController),
            loadingView: WeakRefVirtualProxy(feedController))
        return feedController
    }
}

private extension FeedViewController {
    static func makeWith(delegate: FeedLoaderPresentationAdapter, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = delegate
        feedController.title = title
        return feedController
    }
}

private final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let loader: FeedImageDataLoader

    init(loader: FeedImageDataLoader, controller: FeedViewController) {
        self.loader = loader
        self.controller = controller
    }

    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: loader)
            let view = FeedImageCellController(delegate: adapter)

            adapter.presenter = FeedImagePresenter(
                view: WeakRefVirtualProxy(view),
                imageTransformer: UIImage.init)

            return view
        }
    }
}

private final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
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
