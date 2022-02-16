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
    static func first(with url: URL, in context: NSManagedObjectContext) throws -> ManagedFeedImage? {
        let request = NSFetchRequest<ManagedFeedImage>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedFeedImage.url), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map { localImage in
            let managedImage = ManagedFeedImage(context: context)
            managedImage.id = localImage.id
            managedImage.imageDescription = localImage.description
            managedImage.location = localImage.location
            managedImage.url = localImage.url

            return managedImage
        })
    }

    var local: LocalFeedImage {
        return LocalFeedImage(id: id, location: location, description: imageDescription, url: url)
    }
}
