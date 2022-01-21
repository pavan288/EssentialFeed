//
//  FeedImageLoader.swift
//  EssentialFeediOS
//
//  Created by Pavan Powani on 21/01/22.
//

import Foundation

public protocol FeedImageDataLoaderTask {
    func cancel()
}
public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
