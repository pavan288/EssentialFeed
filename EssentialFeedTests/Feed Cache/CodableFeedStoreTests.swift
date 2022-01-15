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

        do {
            let decoder = JSONDecoder()
            let cache = try decoder.decode(Cache.self, from: data)
            completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
        } catch {
            completion(.failure(error))
        }
    }

    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        do {
            let encoder = JSONEncoder()
            let codableFeed = feed.map({ CodableFeedImage($0) })
            let cache = Cache(feed: codableFeed, timestamp: timestamp)
            let encoded = try encoder.encode(cache)
            try encoded.write(to: storeURL)
            completion(nil)
        } catch {
            completion(error)
        }
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
        expect(sut, toRetrieve: .empty)
        expect(sut, toRetrieve: .empty)
    }

    func test_retrieve_deliversFoundValuesOnEmptyCache() {
        let sut = makeSUT()
        let expectedFeed = uniqueImageFeed().local
        let timeStamp = Date()

        insert((expectedFeed, timestamp: timeStamp), into: sut)
        expect(sut, toRetrieve: .found(feed: expectedFeed, timestamp: timeStamp))
    }

    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let expectedFeed = uniqueImageFeed().local
        let timeStamp = Date()

        insert((expectedFeed, timestamp: timeStamp), into: sut)
        expect(sut, toRetrieve: .found(feed: expectedFeed, timestamp: timeStamp))
        expect(sut, toRetrieve: .found(feed: expectedFeed, timestamp: timeStamp))
    }

    func test_retrieve_deliversFailureOnRetrievalError() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)

        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)

        expect(sut, toRetrieve: .failure(anyNSError()))
    }

    func test_retrieve_hasNoSideEffectsOnFailure() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)

        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)

        expect(sut, toRetrieve: .failure(anyNSError()))
        expect(sut, toRetrieve: .failure(anyNSError()))
    }

    func test_insert_overridesPreviouslyInsertedCachedValues() {
        let sut = makeSUT()

        let firstInsertionError = insert((uniqueImageFeed().local, timestamp: Date()), into: sut)
        XCTAssertNil(firstInsertionError, "Expected to insert to cache successfully")

        let latestFeed = uniqueImageFeed().local
        let latestTimestamp = Date()
        let latestInsertionError = insert((latestFeed, timestamp: latestTimestamp), into: sut)

        XCTAssertNil(latestInsertionError, "Expected to insert to cache successfully")

        expect(sut, toRetrieve: .found(feed: latestFeed, timestamp: latestTimestamp))
    }

    // MARK: - Helpers

    private func makeSUT(storeURL: URL? = nil, file: StaticString = #filePath, line: UInt = #line) -> CodableFeedStore {
        let sut = CodableFeedStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    @discardableResult
    private func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), into sut: CodableFeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?

        sut.insert(cache.feed, timestamp: cache.timestamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully without error")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }

    private func expect(_ sut: CodableFeedStore, toRetrieve expectedResult: RetrieveCacheFeedResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty), (.failure, .failure):
                break
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
