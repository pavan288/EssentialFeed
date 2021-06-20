//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Pavan Powani on 20/06/21.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
