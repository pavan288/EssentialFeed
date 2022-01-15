//
//  CodableFeedStore.swift
//  EssentialFeed
//
//  Created by Pavan Powani on 15/01/22.
//

import Foundation

public class CodableFeedStore: FeedStore {
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

    public init(storeURL: URL) {
        self.storeURL = storeURL
    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
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

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
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

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        guard FileManager.default.fileExists(atPath: storeURL.path) else {
            return completion(nil)
        }
        do {
            try FileManager.default.removeItem(at: storeURL)
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
