//
//  LocalFeedItem.swift
//  EssentialFeed
//
//  Created by Pavan Powani on 10/01/22.
//

import Foundation

public struct LocalFeedItem: Equatable {
    public let id: UUID
    public let location: String?
    public let description: String?
    public let imageURL: URL

    public init(id: UUID, location: String?, description: String?, imageURL: URL) {
        self.id = id
        self.location = location
        self.description = description
        self.imageURL = imageURL
    }
}
