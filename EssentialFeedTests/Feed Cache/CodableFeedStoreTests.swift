//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Pavan Powani on 13/01/22.
//

import XCTest
import EssentialFeed

class CodableFeedStore {
    private struct Cache: Codable {
        var feed: [CodableFeedImage]
        var timestamp: Date

        var localFeed: [LocalFeedImage] {
            return feed.map({ $0.local })
        }
    }

    private struct CodableFeedImage: Codable {
        private let id: UUID
        private let location: String?
        private let description: String?
        private let url: URL

        var local: LocalFeedImage {
            return LocalFeedImage(id: id, location: location, description: description, url: url)
        }

        public init(_ image: LocalFeedImage) {
            self.id = image.id
            self.location = image.location
            self.description = image.description
            self.url = image.url
        }
    }

    private let storeURL: URL

    init(storeURL: URL) {
        self.storeURL = storeURL
    }

    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
    }

    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let codableFeed = feed.map({ CodableFeedImage($0) })
        let cache = Cache(feed: codableFeed, timestamp: timestamp)
        let encoded = try! encoder.encode(cache)
        try! encoded.write(to: storeURL)
        completion(nil)
    }
}

class CodableFeedStoreTests: XCTestCase {
    override func setUp() {
        super.setUp()
        setupEmptyStoreState()
    }

    override func tearDown() {
        super.tearDown()
        undoStoreSideEffects()
    }

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        expect(sut, toRetrieve: .empty)
    }

    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty): break
                default:
                    XCTFail("Expected to receive empty results twice, but got \(firstResult) followed by \(secondResult) instead")
                }
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1.0)
    }

    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = makeSUT()
        let expectedFeed = uniqueImageFeed().local
        let timeStamp = Date()

        let exp = expectation(description: "Wait for cache retrieval")
        sut.insert(expectedFeed, timestamp: timeStamp) { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully without error")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        expect(sut, toRetrieve: .found(feed: expectedFeed, timestamp: timeStamp))
    }

    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")
        let expectedFeed = uniqueImageFeed().local
        let timeStamp = Date()

        sut.insert(expectedFeed, timestamp: timeStamp) { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully without error")

            sut.retrieve { firstResult in
                sut.retrieve { secondResult in
                    switch (firstResult, secondResult) {
                    case let (.found(firstFound), .found(secondFound)):
                        XCTAssertEqual(firstFound.feed, expectedFeed)
                        XCTAssertEqual(firstFound.timestamp, timeStamp)

                        XCTAssertEqual(secondFound.feed, expectedFeed)
                        XCTAssertEqual(secondFound.timestamp, timeStamp)
                    default:
                        XCTFail("Expected retrieving twice from no empty cache to deliver the same found result with the feed \(expectedFeed) and timestamp \(timeStamp), but got \(firstResult) and \(secondResult) instead")
                    }
                    exp.fulfill()
                }
            }
        }
        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CodableFeedStore {
        let sut = CodableFeedStore(storeURL: testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func expect(_ sut: CodableFeedStore, toRetrieve expectedResult: RetrieveCacheFeedResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty): break
            case let (.found(expected), .found(received)):
                XCTAssertEqual(expected.feed, received.feed, file: file, line: line)
                XCTAssertEqual(expected.timestamp, received.timestamp, file: file, line: line)

            default:
                XCTFail("Expected to retrieve \(expectedResult) but got \(retrievedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    private func testSpecificStoreURL() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }

    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }

    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }

    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
}
