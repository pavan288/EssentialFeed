//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Pavan Powani on 28/01/22.
//

import Foundation

struct FeedErrorViewModel {
    let message: String?

    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }

    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
