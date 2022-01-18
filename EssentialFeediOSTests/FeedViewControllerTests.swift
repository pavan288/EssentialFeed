//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Pavan Powani on 18/01/22.
//

import XCTest

final class FeedViewController {
    init(loader: FeedViewControllerTests.LoaderSpy) {

    }
}

class FeedViewControllerTests: XCTestCase {
    func test_init_doesNotInitFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        XCTAssertEqual(loader.loadCallCount, 0)
    }

    // MARK: - Helpers

    class LoaderSpy {
        private(set) var loadCallCount = 0
    }
}
