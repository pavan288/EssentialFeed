//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Pavan Powani on 05/06/21.
//

import XCTest

class RemoteFeedLoader {

}

class HTTPCleint {
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPCleint()
        let _ = RemoteFeedLoader()

        XCTAssertNil(client.requestedURL)
    }
}
