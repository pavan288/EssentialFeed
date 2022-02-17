//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Pavan Powani on 29/01/22.
//

import Foundation

public struct FeedErrorViewModel {
    public let message: String?

    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }

    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
