//
//  ManagedFeedImage.swift
//  EssentialFeed
//
//  Created by Pavan Powani on 16/01/22.
//

import CoreData

@objc(ManagedFeedImage)
internal class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var data: Data?
    @NSManaged var cache: ManagedCache
}

extension ManagedFeedImage {
    internal static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map { localImage in
            let managedImage = ManagedFeedImage(context: context)
            managedImage.id = localImage.id
            managedImage.imageDescription = localImage.description
            managedImage.location = localImage.location
            managedImage.url = localImage.url

            return managedImage
        })
    }

    internal var local: LocalFeedImage {
        return LocalFeedImage(id: id, location: location, description: imageDescription, url: url)
    }
}
