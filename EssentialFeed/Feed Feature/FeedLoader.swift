//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Pavan Powani on 05/06/21.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
