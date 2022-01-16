//
//  CoreDataFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Pavan Powani on 16/01/22.
//

import XCTest
import EssentialFeed

class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }

    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }

    func test_retrieve_deliversFoundValuesOnEmptyCache() {

    }

    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {

    }

    func test_insert_deliversNoErrorOnEmptyCache() {

    }

    func test_insert_deliverNoErrorOnNonEmptyCache() {

    }

    func test_insert_overridesPreviouslyInsertedCachedValues() {

    }

    func test_delete_deliversNoErrorOnEmptyCache() {

    }

    func test_delete_deliversNoErrorOnNonEmptyCache() {

    }

    func test_delete_hasNoSideEffectOnEmptyCache() {

    }

    func test_delete_emptiesPreviouslyInsertedCache() {

    }

    func test_storeSideEffects_runSerially() {

    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataFeedStore {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let sut = try! CoreDataFeedStore(bundle: storeBundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
