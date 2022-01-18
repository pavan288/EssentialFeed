//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Pavan Powani on 18/01/22.
//

import UIKit
import XCTest

final class FeedViewController: UIViewController {
    private var loader: FeedViewControllerTests.LoaderSpy?
    convenience init(loader: FeedViewControllerTests.LoaderSpy) {
        self.init()
        self.loader = loader
    }

    override func viewDidLoad() {
        loader?.load()
    }
}

class FeedViewControllerTests: XCTestCase {
    func test_init_doesNotInitFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        XCTAssertEqual(loader.loadCallCount, 0)
    }

    func test_viewDidLoad_loadsFeed() {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1)
    }

    // MARK: - Helpers

    class LoaderSpy {
        private(set) var loadCallCount = 0

        func load() {
            loadCallCount += 1
        }
    }
}
