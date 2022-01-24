//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Pavan Powani on 21/01/22.
//

import UIKit

protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefresh()
}

public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    @IBOutlet private var view: UIRefreshControl?

    var delegate: FeedRefreshViewControllerDelegate?

    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view?.beginRefreshing()
        } else {
            view?.endRefreshing()
        }
    }


    @IBAction func refresh() {
        delegate?.didRequestFeedRefresh()
    }
}
