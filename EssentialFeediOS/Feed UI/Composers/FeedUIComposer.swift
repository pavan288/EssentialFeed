//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Pavan Powani on 21/01/22.
//

import EssentialFeed

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(loader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let refreshController = FeedRefreshViewController(feedLoader: loader)
        let feedController = FeedViewController(refreshController: refreshController)

        refreshController.onRefresh = { [weak feedController] feed in
            feedController?.tableModel = feed.map({ model in
                FeedImageCellController(model: model, imageLoader: imageLoader)
            })
        }
        return feedController
    }
}
