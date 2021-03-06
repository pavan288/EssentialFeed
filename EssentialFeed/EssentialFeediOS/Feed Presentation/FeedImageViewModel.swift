//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Pavan Powani on 22/01/22.
//

import Foundation

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool

    var hasLocation: Bool {
        return location != nil
    }
}
