//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Pavan Powani on 16/01/22.
//

import Foundation

public final class CoreDataFeedStore: FeedStore {
    public init() {}
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {

    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
}
