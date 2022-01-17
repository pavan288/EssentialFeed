//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Pavan Powani on 05/06/21.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    func load(completion: @escaping (Result) -> Void)
}
