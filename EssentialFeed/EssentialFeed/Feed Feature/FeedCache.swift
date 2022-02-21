//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Pavan Powani on 21/02/22.
//

import Foundation

public protocol FeedCache {
    typealias SaveResult = Result<Void, Error>
    func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
}
