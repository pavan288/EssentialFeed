//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Pavan Powani on 05/06/21.
//

import XCTest

class RemoteFeedLoader {
    let client: HTTPClient
    let url: URL

    init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?

    func get(from url: URL) {
        self.requestedURL = url
    }
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://a-url.com")!
        let client = HTTPClientSpy()
        let _ = RemoteFeedLoader(url: url, client: client)

        XCTAssertNil(client.requestedURL)
    }

    func test_init_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)

        sut.load()

        XCTAssertEqual(client.requestedURL, url)
    }
}
