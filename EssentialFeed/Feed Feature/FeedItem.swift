//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Pavan Powani on 05/06/21.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let location: String?
    let description: String?
    let imageURL: URL
}
