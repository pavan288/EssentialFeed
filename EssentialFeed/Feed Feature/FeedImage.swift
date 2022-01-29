//
//  FeedImage.swift
//  EssentialFeed
//
//  Created by Pavan Powani on 05/06/21.
//

import Foundation

public struct FeedImage: Equatable, Hashable {
    public let id: UUID
    public let location: String?
    public let description: String?
    public let url: URL

    public init(id: UUID, location: String?, description: String?, url: URL) {
        self.id = id
        self.location = location
        self.description = description
        self.url = url
    }
}
