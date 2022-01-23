//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Pavan Powani on 22/01/22.
//

import EssentialFeed

final class FeedImageViewModel<Image> {
    typealias Observer<T> = (T) -> Void

    var task: FeedImageDataLoaderTask?
    var imageLoader: FeedImageDataLoader
    var model: FeedImage
    private let imageTransformer: (Data) -> Image?

    init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }

    var onImageLoad: Observer<Image>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?
    var onImageLoadingStateChange: Observer<Bool>?

    var location: String? {
        return model.location
    }

    var description: String? {
        return model.description
    }

    var hasLocation: Bool {
        return location != nil
    }

    func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        task = imageLoader.loadImageData(from: self.model.url) { [weak self] result in
            self?.handle(result)
        }
    }

    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }

    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }

}
